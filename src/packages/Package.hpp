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
        curlpp::Easy _download;
        std::future<std::map<std::string, HTTPResponse>> _download_future;
        std::vector<Version> _version_cache;

    public:
        std::string name, url_format;

        std::future<std::map<std::string, HTTPResponse>> find_all_versions(curlpp::Multi *client, Version min, Version max) const;
        std::string url_for_version(Version ver) const
        {
            static char urlbuf[URL_MAX_LENGTH];
            snprintf(urlbuf, URL_MAX_LENGTH, url_format.c_str(), ver.major, ver.minor, ver.patch);
            return urlbuf;
        }

        std::vector<Version> get_versions();

        void begin_download(curlpp::Multi &multi);

        virtual void install(const std::filesystem::path &to) = 0;

        virtual ~Package() = default;
    };
}
