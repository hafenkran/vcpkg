#include "pch.h"

#include "PackageSpec.h"
#include "Paragraphs.h"
#include "StatusParagraphs.h"
#include "VcpkgPaths.h"
#include "vcpkg_Dependencies.h"
#include "vcpkg_Files.h"
#include "vcpkg_Graphs.h"
#include "vcpkg_Util.h"
#include "vcpkglib.h"

namespace vcpkg::Dependencies
{
    struct ClusterGraph;
    void mark_plus(const std::string& feature, Cluster& cluster, ClusterGraph& pkg_to_cluster, GraphPlan& graph_plan);
    void mark_minus(Cluster& cluster, ClusterGraph& pkg_to_cluster, GraphPlan& graph_plan);

    bool operator==(const ClusterPtr& l, const ClusterPtr& r) { return l.ptr == r.ptr; }

    std::vector<PackageSpec> AnyParagraph::dependencies(const Triplet& triplet) const
    {
        auto to_package_specs = [&](const std::vector<std::string>& dependencies_as_string) {
            return Util::fmap(dependencies_as_string, [&](const std::string s) {
                return PackageSpec::from_name_and_triplet(s, triplet).value_or_exit(VCPKG_LINE_INFO);
            });
        };

        if (auto p = this->status_paragraph.get())
        {
            return to_package_specs(p->package.depends);
        }

        if (auto p = this->binary_paragraph.get())
        {
            return to_package_specs(p->depends);
        }

        if (auto p = this->source_paragraph.get())
        {
            return to_package_specs(filter_dependencies(p->depends, triplet));
        }

        Checks::exit_with_message(VCPKG_LINE_INFO,
                                  "Cannot get dependencies because there was none of: source/binary/status paragraphs");
    }

    std::string to_output_string(RequestType request_type, const CStringView s)
    {
        switch (request_type)
        {
            case RequestType::AUTO_SELECTED: return Strings::format("  * %s", s);
            case RequestType::USER_REQUESTED: return Strings::format("    %s", s);
            default: Checks::unreachable(VCPKG_LINE_INFO);
        }
    }

    InstallPlanAction::InstallPlanAction()
        : spec(), any_paragraph(), plan_type(InstallPlanType::UNKNOWN), request_type(RequestType::UNKNOWN)
    {
    }

    InstallPlanAction::InstallPlanAction(const PackageSpec& spec,
                                         const SourceControlFile& any_paragraph,
                                         const std::unordered_set<std::string>& features,
                                         const RequestType& request_type)
        : InstallPlanAction()
    {
        this->spec = spec;
        this->request_type = request_type;

        this->plan_type = InstallPlanType::BUILD_AND_INSTALL;
        this->any_paragraph.source_control_file = &any_paragraph;
        this->feature_list = features;
    }

    InstallPlanAction::InstallPlanAction(const PackageSpec& spec,
                                         const AnyParagraph& any_paragraph,
                                         const RequestType& request_type)
        : InstallPlanAction()
    {
        this->spec = spec;
        this->request_type = request_type;
        if (auto p = any_paragraph.status_paragraph.get())
        {
            this->plan_type = InstallPlanType::ALREADY_INSTALLED;
            this->any_paragraph.status_paragraph = *p;
            return;
        }

        if (auto p = any_paragraph.binary_paragraph.get())
        {
            this->plan_type = InstallPlanType::INSTALL;
            this->any_paragraph.binary_paragraph = *p;
            return;
        }

        if (auto p = any_paragraph.source_paragraph.get())
        {
            this->plan_type = InstallPlanType::BUILD_AND_INSTALL;
            this->any_paragraph.source_paragraph = *p;
            return;
        }

        this->plan_type = InstallPlanType::UNKNOWN;
    }

    std::string InstallPlanAction::displayname() const
    {
        if (this->feature_list.empty())
        {
            return this->spec.to_string();
        }
        else
        {
            std::string features;
            for (auto&& feature : this->feature_list)
            {
                features += feature + ",";
            }
            features.pop_back();

            return this->spec.name() + "[" + features + "]:" + this->spec.triplet().to_string();
        }
    }

    bool InstallPlanAction::compare_by_name(const InstallPlanAction* left, const InstallPlanAction* right)
    {
        return left->spec.name() < right->spec.name();
    }

    RemovePlanAction::RemovePlanAction() : plan_type(RemovePlanType::UNKNOWN), request_type(RequestType::UNKNOWN) {}

    RemovePlanAction::RemovePlanAction(const PackageSpec& spec,
                                       const RemovePlanType& plan_type,
                                       const RequestType& request_type)
        : spec(spec), plan_type(plan_type), request_type(request_type)
    {
    }

    bool ExportPlanAction::compare_by_name(const ExportPlanAction* left, const ExportPlanAction* right)
    {
        return left->spec.name() < right->spec.name();
    }

    ExportPlanAction::ExportPlanAction()
        : spec(), any_paragraph(), plan_type(ExportPlanType::UNKNOWN), request_type(RequestType::UNKNOWN)
    {
    }

    ExportPlanAction::ExportPlanAction(const PackageSpec& spec,
                                       const AnyParagraph& any_paragraph,
                                       const RequestType& request_type)
        : ExportPlanAction()
    {
        this->spec = spec;
        this->request_type = request_type;

        if (auto p = any_paragraph.binary_paragraph.get())
        {
            this->plan_type = ExportPlanType::ALREADY_BUILT;
            this->any_paragraph.binary_paragraph = *p;
            return;
        }

        if (auto p = any_paragraph.source_paragraph.get())
        {
            this->plan_type = ExportPlanType::PORT_AVAILABLE_BUT_NOT_BUILT;
            this->any_paragraph.source_paragraph = *p;
            return;
        }

        this->plan_type = ExportPlanType::UNKNOWN;
    }

    bool RemovePlanAction::compare_by_name(const RemovePlanAction* left, const RemovePlanAction* right)
    {
        return left->spec.name() < right->spec.name();
    }

    MapPortFile::MapPortFile(const std::unordered_map<PackageSpec, SourceControlFile>& map) : ports(map) {}

    const SourceControlFile& MapPortFile::get_control_file(const PackageSpec& spec) const
    {
        auto scf = ports.find(spec);
        if (scf == ports.end())
        {
            Checks::exit_fail(VCPKG_LINE_INFO);
        }
        return scf->second;
    }

    PathsPortFile::PathsPortFile(const VcpkgPaths& paths) : ports(paths) {}

    const SourceControlFile& PathsPortFile::get_control_file(const PackageSpec& spec) const
    {
        std::unordered_map<PackageSpec, SourceControlFile>::iterator cache_it = cache.find(spec);
        if (cache_it != cache.end())
        {
            return cache_it->second;
        }
        Parse::ParseExpected<SourceControlFile> source_control_file =
            Paragraphs::try_load_port(ports.get_filesystem(), ports.port_dir(spec));

        if (auto scf = source_control_file.get())
        {
            auto it = cache.emplace(spec, std::move(*scf->get()));
            return it.first->second;
        }
        print_error_message(source_control_file.error());
        Checks::exit_fail(VCPKG_LINE_INFO);
    }

    std::vector<InstallPlanAction> create_install_plan(const PortFileProvider& port_file_provider,
                                                       const std::vector<PackageSpec>& specs,
                                                       const StatusParagraphs& status_db)
    {
        struct InstallAdjacencyProvider final : Graphs::AdjacencyProvider<PackageSpec, InstallPlanAction>
        {
            const PortFileProvider& port_file_provider;
            const StatusParagraphs& status_db;
            const std::unordered_set<PackageSpec>& specs_as_set;

            InstallAdjacencyProvider(const PortFileProvider& port_file_provider,
                                     const StatusParagraphs& s,
                                     const std::unordered_set<PackageSpec>& specs_as_set)
                : port_file_provider(port_file_provider), status_db(s), specs_as_set(specs_as_set)
            {
            }

            std::vector<PackageSpec> adjacency_list(const InstallPlanAction& plan) const override
            {
                if (plan.any_paragraph.status_paragraph.get()) return std::vector<PackageSpec>{};
                return plan.any_paragraph.dependencies(plan.spec.triplet());
            }

            InstallPlanAction load_vertex_data(const PackageSpec& spec) const override
            {
                const RequestType request_type = specs_as_set.find(spec) != specs_as_set.end()
                                                     ? RequestType::USER_REQUESTED
                                                     : RequestType::AUTO_SELECTED;
                auto it = status_db.find_installed(spec);
                if (it != status_db.end()) return InstallPlanAction{spec, {*it->get(), nullopt, nullopt}, request_type};
                return InstallPlanAction{
                    spec, {nullopt, nullopt, *port_file_provider.get_control_file(spec).core_paragraph}, request_type};
            }
        };

        const std::unordered_set<PackageSpec> specs_as_set(specs.cbegin(), specs.cend());
        std::vector<InstallPlanAction> toposort =
            Graphs::topological_sort(specs, InstallAdjacencyProvider{port_file_provider, status_db, specs_as_set});
        Util::erase_remove_if(toposort, [](const InstallPlanAction& plan) {
            return plan.request_type == RequestType::AUTO_SELECTED &&
                   plan.plan_type == InstallPlanType::ALREADY_INSTALLED;
        });

        return toposort;
    }

    std::vector<RemovePlanAction> create_remove_plan(const std::vector<PackageSpec>& specs,
                                                     const StatusParagraphs& status_db)
    {
        struct RemoveAdjacencyProvider final : Graphs::AdjacencyProvider<PackageSpec, RemovePlanAction>
        {
            const StatusParagraphs& status_db;
            const std::vector<StatusParagraph*>& installed_ports;
            const std::unordered_set<PackageSpec>& specs_as_set;

            RemoveAdjacencyProvider(const StatusParagraphs& status_db,
                                    const std::vector<StatusParagraph*>& installed_ports,
                                    const std::unordered_set<PackageSpec>& specs_as_set)
                : status_db(status_db), installed_ports(installed_ports), specs_as_set(specs_as_set)
            {
            }

            std::vector<PackageSpec> adjacency_list(const RemovePlanAction& plan) const override
            {
                if (plan.plan_type == RemovePlanType::NOT_INSTALLED)
                {
                    return {};
                }

                const PackageSpec& spec = plan.spec;
                std::vector<PackageSpec> dependents;
                for (const StatusParagraph* an_installed_package : installed_ports)
                {
                    if (an_installed_package->package.spec.triplet() != spec.triplet()) continue;

                    const std::vector<std::string>& deps = an_installed_package->package.depends;
                    if (std::find(deps.begin(), deps.end(), spec.name()) == deps.end()) continue;

                    dependents.push_back(an_installed_package->package.spec);
                }

                return dependents;
            }

            RemovePlanAction load_vertex_data(const PackageSpec& spec) const override
            {
                const RequestType request_type = specs_as_set.find(spec) != specs_as_set.end()
                                                     ? RequestType::USER_REQUESTED
                                                     : RequestType::AUTO_SELECTED;
                const StatusParagraphs::const_iterator it = status_db.find_installed(spec);
                if (it == status_db.end())
                {
                    return RemovePlanAction{spec, RemovePlanType::NOT_INSTALLED, request_type};
                }
                return RemovePlanAction{spec, RemovePlanType::REMOVE, request_type};
            }
        };

        const std::vector<StatusParagraph*>& installed_ports = get_installed_ports(status_db);
        const std::unordered_set<PackageSpec> specs_as_set(specs.cbegin(), specs.cend());
        return Graphs::topological_sort(specs, RemoveAdjacencyProvider{status_db, installed_ports, specs_as_set});
    }

    std::vector<ExportPlanAction> create_export_plan(const VcpkgPaths& paths,
                                                     const std::vector<PackageSpec>& specs,
                                                     const StatusParagraphs& status_db)
    {
        struct ExportAdjacencyProvider final : Graphs::AdjacencyProvider<PackageSpec, ExportPlanAction>
        {
            const VcpkgPaths& paths;
            const StatusParagraphs& status_db;
            const std::unordered_set<PackageSpec>& specs_as_set;

            ExportAdjacencyProvider(const VcpkgPaths& p,
                                    const StatusParagraphs& s,
                                    const std::unordered_set<PackageSpec>& specs_as_set)
                : paths(p), status_db(s), specs_as_set(specs_as_set)
            {
            }

            std::vector<PackageSpec> adjacency_list(const ExportPlanAction& plan) const override
            {
                return plan.any_paragraph.dependencies(plan.spec.triplet());
            }

            ExportPlanAction load_vertex_data(const PackageSpec& spec) const override
            {
                const RequestType request_type = specs_as_set.find(spec) != specs_as_set.end()
                                                     ? RequestType::USER_REQUESTED
                                                     : RequestType::AUTO_SELECTED;

                Expected<BinaryControlFile> maybe_bpgh = Paragraphs::try_load_cached_control_package(paths, spec);
                if (auto bcf = maybe_bpgh.get())
                    return ExportPlanAction{spec, {nullopt, bcf->core_paragraph, nullopt}, request_type};

                auto maybe_scf = Paragraphs::try_load_port(paths.get_filesystem(), paths.port_dir(spec));
                if (auto scf = maybe_scf.get())
                    return ExportPlanAction{spec, {nullopt, nullopt, *scf->get()->core_paragraph}, request_type};
                else
                    print_error_message(maybe_scf.error());

                Checks::exit_with_message(VCPKG_LINE_INFO, "Could not find package %s", spec);
            }
        };

        const std::unordered_set<PackageSpec> specs_as_set(specs.cbegin(), specs.cend());
        std::vector<ExportPlanAction> toposort =
            Graphs::topological_sort(specs, ExportAdjacencyProvider{paths, status_db, specs_as_set});
        return toposort;
    }

    struct ClusterGraph
    {
        explicit ClusterGraph(std::unordered_map<PackageSpec, Cluster>&& graph) : m_graph(std::move(graph)) {}
        ClusterGraph(ClusterGraph&&) = default;

        Cluster& get(const PackageSpec& spec)
        {
            auto it = m_graph.find(spec);
            if (it == m_graph.end()) Checks::unreachable(VCPKG_LINE_INFO);
            return it->second;
        }

    private:
        ClusterGraph(const ClusterGraph&) = delete;
        std::unordered_map<PackageSpec, Cluster> m_graph;
    };

    void mark_plus(const std::string& feature, Cluster& cluster, ClusterGraph& graph, GraphPlan& graph_plan)
    {
        if (feature == "")
        {
            // Indicates that core was not specified in the reference
            return mark_plus("core", cluster, graph, graph_plan);
        }
        auto it = cluster.edges.find(feature);
        if (it == cluster.edges.end())
        {
            Checks::unreachable(VCPKG_LINE_INFO);
        }

        if (cluster.edges[feature].plus) return;

        if (cluster.original_features.find(feature) == cluster.original_features.end())
        {
            cluster.transient_uninstalled = true;
        }

        if (!cluster.transient_uninstalled)
        {
            return;
        }
        cluster.edges[feature].plus = true;

        if (!cluster.original_features.empty())
        {
            mark_minus(cluster, graph, graph_plan);
        }

        graph_plan.install_graph.add_vertex({&cluster});
        auto& tracked = cluster.to_install_features;
        tracked.insert(feature);

        if (feature != "core")
        {
            // All features implicitly depend on core
            mark_plus("core", cluster, graph, graph_plan);
        }

        for (auto&& depend : cluster.edges[feature].build_edges)
        {
            auto& depend_cluster = graph.get(depend.spec());
            mark_plus(depend.feature(), depend_cluster, graph, graph_plan);
            if (&depend_cluster == &cluster) continue;
            graph_plan.install_graph.add_edge({&cluster}, {&depend_cluster});
        }
    }

    void mark_minus(Cluster& cluster, ClusterGraph& graph, GraphPlan& graph_plan)
    {
        if (cluster.will_remove) return;
        cluster.will_remove = true;

        graph_plan.remove_graph.add_vertex({&cluster});
        for (auto&& pair : cluster.edges)
        {
            auto& remove_edges_edges = pair.second.remove_edges;
            for (auto&& depend : remove_edges_edges)
            {
                auto& depend_cluster = graph.get(depend.spec());
                graph_plan.remove_graph.add_edge({&cluster}, {&depend_cluster});
                mark_minus(depend_cluster, graph, graph_plan);
            }
        }

        cluster.transient_uninstalled = true;
        for (auto&& original_feature : cluster.original_features)
        {
            mark_plus(original_feature, cluster, graph, graph_plan);
        }
    }

    static ClusterGraph create_feature_install_graph(const std::unordered_map<PackageSpec, SourceControlFile>& map,
                                                     const StatusParagraphs& status_db)
    {
        std::unordered_map<PackageSpec, Cluster> graph;

        for (const auto& it : map)
        {
            Cluster& node = graph[it.first];

            node.spec = it.first;
            FeatureNodeEdges core_dependencies;
            core_dependencies.build_edges =
                filter_dependencies_to_specs(it.second.core_paragraph->depends, node.spec.triplet());
            node.edges.emplace("core", std::move(core_dependencies));

            for (const auto& feature : it.second.feature_paragraphs)
            {
                FeatureNodeEdges added_edges;
                added_edges.build_edges = filter_dependencies_to_specs(feature->depends, node.spec.triplet());
                node.edges.emplace(feature->name, std::move(added_edges));
            }
            node.source_control_file = &it.second;
        }

        for (auto&& status_paragraph : get_installed_ports(status_db))
        {
            auto& spec = status_paragraph->package.spec;
            auto& status_paragraph_feature = status_paragraph->package.feature;
            Cluster& cluster = graph[spec];

            cluster.transient_uninstalled = false;
            auto reverse_edges = FeatureSpec::from_strings_and_triplet(status_paragraph->package.depends,
                                                                       status_paragraph->package.spec.triplet());

            for (auto&& dependency : reverse_edges)
            {
                auto pkg_node = graph.find(dependency.spec());
                auto depends_name = dependency.feature();
                if (depends_name == "")
                {
                    for (auto&& default_feature : status_paragraph->package.default_features)
                    {
                        auto& target_node = pkg_node->second.edges[default_feature];
                        target_node.remove_edges.emplace_back(FeatureSpec{spec, status_paragraph_feature});
                    }
                    depends_name = "core";
                }
                auto& target_node = pkg_node->second.edges[depends_name];
                target_node.remove_edges.emplace_back(FeatureSpec{spec, status_paragraph_feature});
            }
            cluster.status_paragraphs.emplace_back(*status_paragraph);
            if (status_paragraph_feature == "")
            {
                cluster.original_features.insert("core");
            }
            else
            {
                cluster.original_features.insert(status_paragraph_feature);
            }
        }
        return ClusterGraph(std::move(graph));
    }

    std::vector<AnyAction> create_feature_install_plan(const std::unordered_map<PackageSpec, SourceControlFile>& map,
                                                       const std::vector<FeatureSpec>& specs,
                                                       const StatusParagraphs& status_db)
    {
        ClusterGraph graph = create_feature_install_graph(map, status_db);

        GraphPlan graph_plan;
        for (auto&& spec : specs)
        {
            Cluster& spec_cluster = graph.get(spec.spec());
            mark_plus(spec.feature(), spec_cluster, graph, graph_plan);
        }

        Graphs::GraphAdjacencyProvider<ClusterPtr> adjacency_remove_graph(graph_plan.remove_graph.adjacency_list());
        auto remove_vertex_list = graph_plan.remove_graph.vertex_list();
        auto remove_toposort = Graphs::topological_sort(remove_vertex_list, adjacency_remove_graph);

        Graphs::GraphAdjacencyProvider<ClusterPtr> adjacency_install_graph(graph_plan.install_graph.adjacency_list());
        auto insert_vertex_list = graph_plan.install_graph.vertex_list();
        auto insert_toposort = Graphs::topological_sort(insert_vertex_list, adjacency_install_graph);

        std::vector<AnyAction> install_plan;

        for (auto&& like_cluster : remove_toposort)
        {
            auto scf = *like_cluster.ptr->source_control_file.get();

            AnyAction any_plan;
            any_plan.remove_plan = RemovePlanAction{
                PackageSpec::from_name_and_triplet(scf->core_paragraph->name, like_cluster.ptr->spec.triplet())
                    .value_or_exit(VCPKG_LINE_INFO),
                RemovePlanType::REMOVE,
                RequestType::AUTO_SELECTED};

            install_plan.emplace_back(std::move(any_plan));
        }

        for (auto&& like_cluster : insert_toposort)
        {
            if (!like_cluster.ptr->transient_uninstalled) continue;

            auto scf = *like_cluster.ptr->source_control_file.get();
            auto pkg_spec =
                PackageSpec::from_name_and_triplet(scf->core_paragraph->name, like_cluster.ptr->spec.triplet())
                    .value_or_exit(VCPKG_LINE_INFO);
            auto action =
                InstallPlanAction{pkg_spec, *scf, like_cluster.ptr->to_install_features, RequestType::AUTO_SELECTED};

            AnyAction any_plan;
            any_plan.install_plan = std::move(action);
            install_plan.emplace_back(std::move(any_plan));
        }

        return install_plan;
    }
}
