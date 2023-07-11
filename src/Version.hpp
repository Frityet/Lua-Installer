#pragma once

#include "utilities.hpp"
#include <string>
#include <cstring>

struct alignas(8) Version {
    uint16_t major, minor, patch;

    bool operator<(const Version &other) const
    {
        return major < other.major || minor < other.minor || patch < other.patch;
    }

    bool operator>(const Version &other) const
    {
        return major > other.major || minor > other.minor || patch > other.patch;
    }

    bool operator==(const Version &other) const
    {
        return major == other.major && minor == other.minor && patch == other.patch;
    }

    bool operator!=(const Version &other) const
    {
        return !(*this == other);
    }

    bool operator<=(const Version &other) const
    {
        return *this < other || *this == other;
    }

    bool operator>=(const Version &other) const
    {
        return *this > other || *this == other;
    }

    std::string to_string() const
    {
        static char buf[32];
        snprintf(buf, 32, "%d.%d.%d", major, minor, patch);
        return buf;
    }

    std::string to_url(const std::string &url_fmt)
    {
        static char buf[URL_MAX_LENGTH];
        snprintf(buf, URL_MAX_LENGTH, url_fmt.c_str(), major, minor, patch);
        return buf;
    }

    static Version from_string(const std::string &str)
    {
        Version version;
        int major, minor, patch;
        std::sscanf(str.c_str(), "%d.%d.%d", &major, &minor, &patch);
        version.major = major;
        version.minor = minor;
        version.patch = patch;
        return version;
    }
};
