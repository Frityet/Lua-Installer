#include "Lua.hpp"

using namespace packages;

Lua::Lua() : Package("Lua", "https://www.lua.org/ftp/lua-%d.%d.%d.tar.gz", Version { 5, 0, 0 }, { 5, 10, 10 })
{

}

void Lua::install(const std::filesystem::path &to)
{

}
