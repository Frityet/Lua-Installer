local Package = require("Package")
local https = require("https")
local json = require("json")
local Version = require("Package/Version")
local MinGWVersion = require("Package/MinGW/Version")

---@alias MinGW.Type
---| '"MinGW"'
---| '"LLVM"'
---| '"w64devkit"'

---@class MinGW : Package
---@field versions Package.MinGW.Version[]
---@field type MinGW.Type
local MinGW = {
    ---@type MinGW.Type
    type = "MinGW",
    ---@type MinGW.Type[]
    TYPES = { "MinGW", "LLVM", "w64devkit" },

    API_ENDPOINTS = {
        MinGW = "https://api.github.com/repos/niXman/mingw-builds-binaries/releases",
        LLVM = "https://api.github.com/repos/mstorsjo/llvm-mingw/releases",
        w64devkit = "https://api.github.com/repos/skeeto/w64devkit/releases"
    },

    ---Depends on `type`
    url_format = ""
}
MinGW.__index = MinGW
MinGW.__name = "MinGW"
setmetatable(MinGW, Package)

---@return MinGW
function MinGW:create()
    return setmetatable(Package.create(self), MinGW) --[[@as MinGW]]
end

local fetch = {
    ---@param self MinGW
    ---@param on_get fun(ver: Package.MinGW.Version?, checked: integer, total: integer)?
    ---@return luvit.http.ClientRequest
    MinGW = function (self, on_get)
        self.versions = {}

        local req = https.get(MinGW.API_ENDPOINTS.MinGW, function (res)
            local data = ""
            res:on("error", error)
            res:on("data", function (chunk) data = data.. chunk end)
            res:on("end", function ()
                local releases = assert(json.decode(data))
                for _, release in ipairs(releases) do
                    local tag_name = release.tag_name
                    local version = MinGWVersion:from_string(tag_name)
                    if version then
                        table.insert(self.versions, version)
                        if on_get then on_get(version, #self.versions, #releases) end
                    else print("Invalid version: "..tag_name) end
                end
            end)
        end)

        req:on("error", error)

        req:flushHeaders()
        req:done()
        return req
    end,

    ---@param self MinGW
    ---@param on_get fun(ver: Package.Version?, checked: integer, total: integer)?
    ---@return luvit.http.ClientRequest
    LLVM = function (self, on_get)
        self.versions = {}

        local req = https.get(MinGW.API_ENDPOINTS.LLVM, function (res)
            local data = ""
            res:on("error", error)
            res:on("data", function (chunk) data = data.. chunk end)
            res:on("end", function ()
                local releases = assert(json.decode(data))
                for _, release in ipairs(releases) do
                    if release.prerelease then goto next end


                    --LLVM has an incredibly bad tag name so we need to use the release name instead
                    --example release name:  llvm-mingw 20230919 with LLVM 17.0.1 Latest
                    --example tag name:     20230919

                    --ignore everything exceot for LLVM version
                    local major, minor, build = release.name:match("(%d+)%.(%d+)%.(%d+)")
                    if not major or not minor or not build then goto next end
                    local version = Version:create(assert(tonumber(major)), assert(tonumber(minor)), assert(tonumber(build)))
                    table.insert(self.versions, version)
                    if on_get then on_get(version, #self.versions, #releases) end

                    ::next::
                end
            end)
        end)

        req:on("error", error)

        req:flushHeaders()
        req:done()
        return req
    end,

    ---@param self MinGW
    ---@param on_get fun(ver: Package.Version?, checked: integer, total: integer)?
    ---@return luvit.http.ClientRequest
    w64devkit = function(self, on_get)
        self.versions = {}

        local req = https.get(MinGW.API_ENDPOINTS.w64devkit, function (res)
            local data = ""
            res:on("error", error)
            res:on("data", function (chunk) data = data.. chunk end)
            res:on("end", function ()
                local releases = assert(json.decode(data))
                for _, release in ipairs(releases) do
                    if release.prerelease then goto next end

                    local tag_name = release.tag_name
                    local version = Version:from_string(tag_name)
                    if version then
                        table.insert(self.versions, version)
                        if on_get then on_get(version, #self.versions, #releases) end
                    else io.stderr:write("Invalid version: "..tag_name) end

                    ::next::
                end
            end)
        end)

        req:on("error", error)

        req:flushHeaders()
        req:done()
        return req
    end

}


---@overload fun(type: "MinGW", on_get: fun(ver: Package.MinGW.Version?, checked: integer, total: integer)?): luvit.http.ClientRequest
---@overload fun(type: "LLVM", on_get: fun(ver: Package.Version?, checked: integer, total: integer)?): luvit.http.ClientRequest
---@overload fun(type: "w64devkit", on_get: fun(ver: Package.Version?, checked: integer, total: integer)?): luvit.http.ClientRequest
---@param type MinGW.Type
---@param on_get fun(ver: Package.Version?, checked: integer, total: integer)?
---@return luvit.http.ClientRequest
function MinGW:fetch_versions(type, on_get)
    self.type = type

    return fetch[self.type](self, on_get)
end

return MinGW
