#pragma once

#include <vcpkg/fwd/cmakevars.h>
#include <vcpkg/fwd/portfileprovider.h>

#include <vcpkg/base/optional.h>
#include <vcpkg/base/util.h>

#include <vcpkg/build.h>
#include <vcpkg/packagespec.h>

#include <functional>
#include <map>
#include <vector>

namespace vcpkg::Graphs
{
    struct Randomizer;
}

namespace vcpkg
{
    struct StatusParagraphs;
}

namespace vcpkg::Dependencies
{
    enum class RequestType
    {
        UNKNOWN,
        USER_REQUESTED,
        AUTO_SELECTED
    };

    std::string to_output_string(RequestType request_type,
                                 const CStringView s,
                                 const Build::BuildPackageOptions& options);
    std::string to_output_string(RequestType request_type, const CStringView s);

    enum class InstallPlanType
    {
        UNKNOWN,
        BUILD_AND_INSTALL,
        ALREADY_INSTALLED,
        EXCLUDED
    };

    struct InstallPlanAction : Util::MoveOnlyBase
    {
        static bool compare_by_name(const InstallPlanAction* left, const InstallPlanAction* right);

        InstallPlanAction() noexcept;

        InstallPlanAction(InstalledPackageView&& spghs, const RequestType& request_type);

        InstallPlanAction(const PackageSpec& spec,
                          const SourceControlFileLocation& scfl,
                          const RequestType& request_type,
                          std::map<std::string, std::vector<FeatureSpec>>&& dependencies);

        std::string displayname() const;
        const std::string& public_abi() const;
        bool has_package_abi() const;
        Optional<const std::string&> package_abi() const;
        const Build::PreBuildInfo& pre_build_info(LineInfo linfo) const;

        PackageSpec spec;

        Optional<const SourceControlFileLocation&> source_control_file_location;
        Optional<InstalledPackageView> installed_package;

        InstallPlanType plan_type;
        RequestType request_type;
        Build::BuildPackageOptions build_options;

        std::map<std::string, std::vector<FeatureSpec>> feature_dependencies;
        std::vector<PackageSpec> package_dependencies;
        std::vector<std::string> feature_list;

        Optional<Build::AbiInfo> abi_info;
    };

    enum class RemovePlanType
    {
        UNKNOWN,
        NOT_INSTALLED,
        REMOVE
    };

    struct RemovePlanAction : Util::MoveOnlyBase
    {
        static bool compare_by_name(const RemovePlanAction* left, const RemovePlanAction* right);

        RemovePlanAction() noexcept;
        RemovePlanAction(const PackageSpec& spec, const RemovePlanType& plan_type, const RequestType& request_type);

        PackageSpec spec;
        RemovePlanType plan_type;
        RequestType request_type;
    };

    struct ActionPlan
    {
        bool empty() const { return remove_actions.empty() && already_installed.empty() && install_actions.empty(); }
        size_t size() const { return remove_actions.size() + already_installed.size() + install_actions.size(); }

        std::vector<RemovePlanAction> remove_actions;
        std::vector<InstallPlanAction> already_installed;
        std::vector<InstallPlanAction> install_actions;
    };

    enum class ExportPlanType
    {
        UNKNOWN,
        NOT_BUILT,
        ALREADY_BUILT
    };

    struct ExportPlanAction : Util::MoveOnlyBase
    {
        static bool compare_by_name(const ExportPlanAction* left, const ExportPlanAction* right);

        ExportPlanAction() noexcept;
        ExportPlanAction(const PackageSpec& spec,
                         InstalledPackageView&& installed_package,
                         const RequestType& request_type);

        ExportPlanAction(const PackageSpec& spec, const RequestType& request_type);

        PackageSpec spec;
        ExportPlanType plan_type;
        RequestType request_type;

        Optional<const BinaryParagraph&> core_paragraph() const;
        std::vector<PackageSpec> dependencies() const;

    private:
        Optional<InstalledPackageView> m_installed_package;
    };

    struct ClusterGraph;

    struct CreateInstallPlanOptions
    {
        Graphs::Randomizer* randomizer = nullptr;
    };

    std::vector<RemovePlanAction> create_remove_plan(const std::vector<PackageSpec>& specs,
                                                     const StatusParagraphs& status_db);

    std::vector<ExportPlanAction> create_export_plan(const std::vector<PackageSpec>& specs,
                                                     const StatusParagraphs& status_db);

    /// <summary>Figure out which actions are required to install features specifications in `specs`.</summary>
    /// <param name="provider">Contains the ports of the current environment.</param>
    /// <param name="specs">Feature specifications to resolve dependencies for.</param>
    /// <param name="status_db">Status of installed packages in the current environment.</param>
    ActionPlan create_feature_install_plan(const PortFileProvider::PortFileProvider& provider,
                                           const CMakeVars::CMakeVarProvider& var_provider,
                                           const std::vector<FullPackageSpec>& specs,
                                           const StatusParagraphs& status_db,
                                           const CreateInstallPlanOptions& options = {});

    ActionPlan create_upgrade_plan(const PortFileProvider::PortFileProvider& provider,
                                   const CMakeVars::CMakeVarProvider& var_provider,
                                   const std::vector<PackageSpec>& specs,
                                   const StatusParagraphs& status_db,
                                   const CreateInstallPlanOptions& options = {});

    // `features` should have "default" instead of missing "core". This is only exposed for testing purposes.
    std::vector<FullPackageSpec> resolve_deps_as_top_level(const SourceControlFile& scf,
                                                           Triplet triplet,
                                                           std::vector<std::string> features,
                                                           CMakeVars::CMakeVarProvider& var_provider);

    /// <param name="provider">Contains the ports of the current environment.</param>
    /// <param name="specs">Feature specifications to resolve dependencies for.</param>
    /// <param name="status_db">Status of installed packages in the current environment.</param>
    ExpectedS<ActionPlan> create_versioned_install_plan(const PortFileProvider::IVersionedPortfileProvider& vprovider,
                                                        const PortFileProvider::IBaselineProvider& bprovider,
                                                        const PortFileProvider::IOverlayProvider& oprovider,
                                                        const CMakeVars::CMakeVarProvider& var_provider,
                                                        const std::vector<Dependency>& deps,
                                                        const std::vector<DependencyOverride>& overrides,
                                                        const PackageSpec& toplevel);

    void print_plan(const ActionPlan& action_plan, const bool is_recursive = true, const fs::path& vcpkg_root_dir = {});
}
