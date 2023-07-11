#include "Package.hpp"

using namespace packages;

Package::Package(const std::string &name, const std::string &url_format, Version min, Version max)
{
    this->name = name;
    this->url_format = url_format;

    std::vector<std::string> urls;

    for (int i = min.major; i <= max.major; i++) {
        for (int j = min.minor; j <= max.minor; j++) {
            for (int k = min.patch; k <= max.patch; k++) {
                static char urlbuf[URL_MAX_LENGTH];
                snprintf(urlbuf, URL_MAX_LENGTH, url_format.c_str(), i, j, k);
                urls.push_back(urlbuf);
            }
        }
    }

    _version_request = request_many_async(&this->_version_dl_client, urls, HTTPMethod::HEAD);
}

bool Package::finished_fetching_versions() const
{
    return _version_request.wait_for(std::chrono::seconds(0)) == std::future_status::ready;
}

const std::vector<Version> &Package::get_versions()
{
    if (_version_cache.size() == 0) {
        auto responses = _version_request.get();
        for (auto &response : responses) {
            if (response.second.code == 200) {
                Version v;
                sscanf(response.first.c_str(), url_format.c_str(), &v.major, &v.minor, &v.patch);
                _version_cache.push_back(v);
            }
        }
    }

    return _version_cache;
}
