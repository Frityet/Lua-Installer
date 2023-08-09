#pragma once

#include "Package.hpp"

namespace packages
{
    class MinGW : public Package {
    public:
        MinGW();
        void install(const std::filesystem::path &to) override;
    };
}
