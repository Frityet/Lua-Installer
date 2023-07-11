#include "Version.hpp"

#include <vector>
#include <string>

std::future<std::map<std::string, HTTPResponse>> Version::find_all_versions(curlpp::Multi *client, Version min, Version max) const
{
    std::vector<std::string> urls;

    for (int i = min.major; i <= max.major; i++) {
        for (int j = min.minor; j <= max.minor; j++) {
            for (int k = min.patch; k <= max.patch; k++) {
                urls.push_back(Version {
                    .major = i,
                    .minor = j,
                    .patch = k,
                    .url_format = url_format
                }.url());
            }
        }
    }

    return request_many_async(client, urls, HTTPMethod::HEAD);
}
