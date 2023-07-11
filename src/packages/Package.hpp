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
        curlpp::Multi _version_dl_client;
        std::future<std::map<std::string, HTTPResponse>> _version_request;
        std::vector<Version> _version_cache;
        std::future<void> _dl_thread;

    public:
        struct DownloadProgress {
            double progress;
            double total;
        } progress;

        std::string name, url_format;
        Version version;

        Package(const std::string &name, const std::string &url_format, Version min, Version max);

        //Ref to _version_cache
        const std::vector<Version> &versions();
        bool finished_fetching_versions() const;

        void begin_download(const std::filesystem::path &to);

        virtual void install(const std::filesystem::path &to) = 0;
    };
}
