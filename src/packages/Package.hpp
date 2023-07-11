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

    public:
        std::string name;
        Version version;

        void begin_download(curlpp::Multi &multi);

        virtual void install(const std::filesystem::path &to) = 0;

        virtual ~Package() = default;
    };
}
