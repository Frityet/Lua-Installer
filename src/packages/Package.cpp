#include "Package.hpp"

using namespace packages;

std::future<std::map<std::string, HTTPResponse>> Package::find_all_versions(curlpp::Multi *client, Version min, Version max) const
{
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

    return request_many_async(client, urls, HTTPMethod::HEAD);
}
