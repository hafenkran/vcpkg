#include "pch.h"

#include <vcpkg/base/checks.h>
#include <vcpkg/statusparagraphs.h>

namespace vcpkg
{
    StatusParagraphs::StatusParagraphs() = default;

    StatusParagraphs::StatusParagraphs(std::vector<std::unique_ptr<StatusParagraph>>&& ps)
        : paragraphs(std::move(ps)){};

    std::vector<std::unique_ptr<StatusParagraph>*> StatusParagraphs::find_all(const std::string& name,
                                                                              const Triplet& triplet)
    {
        std::vector<std::unique_ptr<StatusParagraph>*> spghs;
        for (auto&& p : *this)
        {
            if (p->package.spec.name() == name && p->package.spec.triplet() == triplet)
            {
                if (p->package.feature.empty())
                    spghs.emplace(spghs.begin(), &p);
                else
                    spghs.emplace_back(&p);
            }
        }
        return spghs;
    }

    Optional<InstalledPackageView> StatusParagraphs::find_all_installed(const PackageSpec& spec) const
    {
        InstalledPackageView ipv;
        for (auto&& p : *this)
        {
            if (p->package.spec.name() == spec.name() && p->package.spec.triplet() == spec.triplet() &&
                p->is_installed())
            {
                if (p->package.feature.empty())
                {
                    Checks::check_exit(VCPKG_LINE_INFO, ipv.core == nullptr);
                    ipv.core = p.get();
                }
                else
                    ipv.features.emplace_back(p.get());
            }
        }
        if (ipv.core != nullptr)
            return std::move(ipv);
        else
            return nullopt;
    }

    StatusParagraphs::iterator StatusParagraphs::find(const std::string& name,
                                                      const Triplet& triplet,
                                                      const std::string& feature)
    {
        if (feature == "core")
        {
            // The core feature maps to .feature == ""
            return find(name, triplet, "");
        }
        return std::find_if(begin(), end(), [&](const std::unique_ptr<StatusParagraph>& pgh) {
            const PackageSpec& spec = pgh->package.spec;
            return spec.name() == name && spec.triplet() == triplet && pgh->package.feature == feature;
        });
    }

    StatusParagraphs::const_iterator StatusParagraphs::find(const std::string& name,
                                                            const Triplet& triplet,
                                                            const std::string& feature) const
    {
        if (feature == "core")
        {
            // The core feature maps to .feature == ""
            return find(name, triplet, "");
        }
        return std::find_if(begin(), end(), [&](const std::unique_ptr<StatusParagraph>& pgh) {
            const PackageSpec& spec = pgh->package.spec;
            return spec.name() == name && spec.triplet() == triplet && pgh->package.feature == feature;
        });
    }

    StatusParagraphs::const_iterator StatusParagraphs::find_installed(const PackageSpec& spec) const
    {
        auto it = find(spec);
        if (it != end() && (*it)->is_installed())
        {
            return it;
        }
        else
        {
            return end();
        }
    }

    StatusParagraphs::const_iterator StatusParagraphs::find_installed(const FeatureSpec& spec) const
    {
        auto it = find(spec);
        if (it != end() && (*it)->is_installed())
        {
            return it;
        }
        else
        {
            return end();
        }
    }

    bool vcpkg::StatusParagraphs::is_installed(const PackageSpec& spec) const
    {
        auto it = find(spec);
        return it != end() && (*it)->is_installed();
    }

    bool vcpkg::StatusParagraphs::is_installed(const FeatureSpec& spec) const
    {
        auto it = find(spec);
        return it != end() && (*it)->is_installed();
    }

    //bool vcpkg::StatusParagraphs::needs_rebuild(const PackageSpec& spec)
    //{
    //    auto it = find(spec);
    //    if (it != end())
    //    {
    //        for (const std::string& dep : (*it)->package.depends)
    //        {
    //            PackageSpec dep_spec =
    //                PackageSpec::from_name_and_triplet(
    //                        dep,
    //                        spec.triplet()).value_or_exit(VCPKG_LINE_INFO);

    //            if (needs_rebuild(dep_spec))
    //            {
    //                (*it)->state = InstallState::NEEDS_REBUILD;
    //                return true;
    //            }
    //        }

    //        return (*it)->needs_rebuild();
    //    }

    //    return false;
    //}

    StatusParagraphs::iterator StatusParagraphs::insert(std::unique_ptr<StatusParagraph> pgh)
    {
        Checks::check_exit(VCPKG_LINE_INFO, pgh != nullptr, "Inserted null paragraph");
        const PackageSpec& spec = pgh->package.spec;
        const auto ptr = find(spec.name(), spec.triplet(), pgh->package.feature);
        if (ptr == end())
        {
            paragraphs.push_back(std::move(pgh));
            return paragraphs.rbegin();
        }

        // consume data from provided pgh.
        **ptr = std::move(*pgh);
        return ptr;
    }

    void serialize(const StatusParagraphs& pghs, std::string& out_str)
    {
        for (auto& pgh : pghs.paragraphs)
        {
            serialize(*pgh, out_str);
            out_str.push_back('\n');
        }
    }
}
