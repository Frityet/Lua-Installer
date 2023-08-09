#pragma once

#include "Package.hpp"

namespace packages
{
    class Lua : public Package {
    public:
        Lua();
        void install(const std::filesystem::path &to) override;
    };
}
