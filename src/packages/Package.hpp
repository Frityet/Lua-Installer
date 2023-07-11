#pragma once

#include <vector>
#include <filesystem>

#include <curlpp/cURLpp.hpp>
#include <curlpp/Easy.hpp>
#include <curlpp/Multi.hpp>

#include "Version.hpp"

namespace packages
{
    class Package {
    private:
        std::future<std::map<std::string, HTTPResponse>> _version_request;
        std::vector<Version> _version_cache;
        curlpp::Multi _version_dl_client;
        curlpp::Easy _client;

    public:
        std::string name, url_format;
        Version version;

        Package(const std::string &name, const std::string &url_format, Version min, Version max);

        //Ref to _version_cache
        const std::vector<Version> &get_versions();
        bool finished_fetching_versions() const;


        virtual void install(const std::filesystem::path &to) = 0;
    };
}
