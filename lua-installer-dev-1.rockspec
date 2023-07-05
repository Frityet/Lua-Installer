---@diagnostic disable: lowercase-global
rockspec_format = "3.0"
package = "lua-installer"
version = "dev-1"
source = {
    url = "git+https://github.com/Frityet/Lua-Installer.git"
}
description = {
    summary = "Installer for lua",
    homepage = "https://github.com/Frityet/Lua-Installer",
    license = "GPLv3"
}
build = {
    type = "builtin",
    install = {
        bin = {
            ["lua-installer"] = "src/main.lua"
        }
    },

    modules = {

    }
}
build_dependencies = {
    "combustion",
}
dependencies = {
    "lua ~> 5.4",
    "luayue-bin"
}
