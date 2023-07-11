#include "Package.hpp"

namespace packages
{
    class Lua : public Package {
        void install(const std::filesystem::path &to) override;
    };
}
