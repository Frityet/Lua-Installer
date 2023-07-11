#include "MinGW.hpp"

using namespace packages;

MinGW::MinGW() : Package("MinGW", "https://github.com/niXman/mingw-builds-binaries/releases/download/%d.%d.%d-rt_v11-rev1/x86_64-%d.%d.%d-release-win32-seh-ucrt-rt_v11-rev1.7z", Version { 13, 1, 0 }, Version { 13, 1, 0 })
{
}

void MinGW::install(const std::filesystem::path &to)
{

}
