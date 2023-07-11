#include "Package.hpp"

namespace packages
{
    class MinGW : public Package {
        void install(const std::filesystem::path &to) override;
    };
}
