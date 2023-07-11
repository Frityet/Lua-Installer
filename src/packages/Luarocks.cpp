#include "Luarocks.hpp"
#include "Version.hpp"

using namespace packages;

Luarocks::Luarocks() : Package("Luarocks", "https://luarocks.github.io/luarocks/releases/luarocks-%d.%d.%d-windows-64.zip",
                                Version { 3, 0, 0 }, Version { 4, 10, 10 })
{

}

void Luarocks::install(const std::filesystem::path &to)
{

}
