#pragma once

#include "utilities.hpp"
#include <string>
#include <cstring>

struct Version {
    int major, minor, patch;

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

    static constexpr Version from_string(const std::string &str)
    {
        Version version;
        std::sscanf(str.c_str(), "%d.%d.%d", &version.major, &version.minor, &version.patch);
        return version;
    }
};

//Literal
constexpr Version operator""_v(const char *str, size_t len)
{ return Version::from_string(std::string(str, len)); }
