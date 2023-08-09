#pragma once

#include "Package.hpp"

namespace packages
{
    class Luarocks : public Package {
    public:
        Luarocks();
        void install(const std::filesystem::path &to) override;
    };
}
