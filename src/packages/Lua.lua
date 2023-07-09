local Package = require("packages.Package")

---@class Packages.Lua : Package
local Lua = {
    name = "Lua"
}
setmetatable(Lua, { __index = Package })

---@param ver Package.Version
---@return Packages.Lua
function Lua.create(ver)
    return setmetatable(Package.create("https://www.lua.org/ftp/lua-%d.%d.%d.tar.gz", ver), Lua) --[[@as Packages.Lua]]
end

function Lua.find_versions()
    return Package.find_versions("https://www.lua.org/ftp/lua-%d.%d.%d.tar.gz", {
        major = 5,
        minor = 1,
        patch = 0,
    }, {
        major = 5,
        minor = 10,
        patch = 10,
    })
end

---@param out { result: Package.Version[] }
function Lua.find_versions_async(out)
    return Package.find_versions_async("https://www.lua.org/ftp/lua-%d.%d.%d.tar.gz", {
        major = 5,
        minor = 1,
        patch = 0,
    }, {
        major = 5,
        minor = 10,
        patch = 10,
    }, out)
end

return Lua
