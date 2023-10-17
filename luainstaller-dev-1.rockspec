---@diagnostic disable: lowercase-global
rockspec_format = "3.0"
package = "LuaInstaller"
version = "dev-1"
source = {
    url = "git+https://github.com/Frityet/Lua-Installer.git"
}
description = {
    summary = "Installer for lua and luarocks, plus other goodies",
    homepage = "https://github.com/Frityet/Lua-Installer",
    license = "GPLv3"
}
dependencies = {
    "lua ~> 5.1",
    "luayue 0.14.1-bin",
    "htmlparser",
}
build_dependencies = {
    "luarocks-build-extended"
}
build = {
    type = "extended",
    modules = {
    }
}
