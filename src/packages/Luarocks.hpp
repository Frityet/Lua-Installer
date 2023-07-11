#include "Package.hpp"

namespace packages
{
    class Luarocks : public Package {
        void install(const std::filesystem::path &to) override;
    };
}
