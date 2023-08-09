#include "packages/Lua.hpp"
#include "packages/Luarocks.hpp"
#include "packages/MinGW.hpp"

int main()
{
    auto lua = packages::Lua();
    auto luarocks = packages::Luarocks();
    auto mingw = packages::MinGW();
}
