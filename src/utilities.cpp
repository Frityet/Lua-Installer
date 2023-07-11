#include "utilities.hpp"

#include <sstream>

#include <curlpp/cURLpp.hpp>
#include <curlpp/Easy.hpp>
#include <curlpp/Multi.hpp>
#include <curlpp/Infos.hpp>

#include <curlpp/Options.hpp>

std::future<HTTPResponse> request_async(const std::string &url, HTTPMethod method)
{
    return std::async(std::launch::async, [](const std::string &url, HTTPMethod method) {
        curlpp::Easy request;
        request.setOpt(curlpp::options::Url(url));
        request.setOpt(curlpp::options::FollowLocation(true));

        const char *req;
        #define M(x) case HTTPMethod::x: req = #x; break
        switch (method) {
            M(GET);
            M(POST);
            M(HEAD);
        }
        #undef M

        request.setOpt(curlpp::options::CustomRequest(req));

        std::ostringstream response;
        request.setOpt(curlpp::options::WriteStream(&response));

        request.perform();
        return HTTPResponse {
            .data = std::move(response).str(),
            .code = curlpp::infos::ResponseCode::get(request)
        };
    }, url, method);
}

std::future<std::map<std::string, HTTPResponse>>
request_many_async(curlpp::Multi *client, const std::vector<std::string> &urls, HTTPMethod method)
{
    return std::async(std::launch::async, [](curlpp::Multi *client, const std::vector<std::string> &urls, HTTPMethod method) {
        std::map<std::string, HTTPResponse> responses;
        std::vector<std::tuple<std::unique_ptr<std::ostringstream>, std::unique_ptr<curlpp::Easy>>> requests;
        for (const std::string &url : urls) {
            auto out = std::make_unique<std::ostringstream>();
            auto request = std::make_unique<curlpp::Easy>();
            request->setOpt(curlpp::options::Url(url));
            request->setOpt(curlpp::options::FollowLocation(true));

            const char *req;
            #define M(x) case HTTPMethod::x: req = #x; break
            switch (method) {
                M(GET);
                M(POST);
                M(HEAD);
            }
            #undef M

            request->setOpt(curlpp::options::CustomRequest(req));

            request->setOpt(curlpp::options::WriteStream(out.get()));

            requests.push_back({ std::move(out), std::move(request) });
        }

        for (const std::tuple<std::unique_ptr<std::ostringstream>, std::unique_ptr<curlpp::Easy>> &request : requests)
                client->add(std::get<1>(request).get());

        int running;
        do {
            client->perform(&running);
        } while (running);

        for (const std::tuple<std::unique_ptr<std::ostringstream>, std::unique_ptr<curlpp::Easy>> &request : requests) {
            const auto &[response, http] = request;

            auto url = curlpp::options::Url();
            http->getOpt(url);
            responses[url.getValue()] = HTTPResponse {
                .data = std::move(*response).str(),
                .code = curlpp::infos::ResponseCode::get(*http)
            };
        }

        return responses;
    }, client, urls, method);
}
