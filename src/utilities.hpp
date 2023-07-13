#pragma once

#include <future>
#include <initializer_list>
#include <map>
#include <vector>
#include <curlpp/Multi.hpp>

enum class HTTPMethod {
    GET,
    POST,
    HEAD,
};

constexpr int URL_MAX_LENGTH = 4096;

struct HTTPResponse {
    std::string data;
    long code;
};

std::future<HTTPResponse> request_async(const std::string &url, HTTPMethod method);

std::future<std::map<std::string, HTTPResponse>>
request_many_async(curlpp::Multi *client, const std::vector<std::string> &urls, HTTPMethod method);
