---@type copas
local copas = require("copas")

require("socket")
---@type ssl.https
local https = require("ssl.https")
---@type ltn12
local ltn12 = require("ltn12")

---@class Package
local Package = {
    url_format = "",
    ---@class Package.Version
    version = {
        major = 0,
        minor = 0,
        patch = 0,
    },

    ---@type string
    name = nil, --intentionally nil, overwritten by subclasses (static field)
}
setmetatable(Package, { __index = Package })

---@param url_fmt string
---@param ver Package.Version
---@return Package
function Package.create(url_fmt, ver)
    return setmetatable({
        url_format = url_fmt,
        version = ver,
    }, Package)
end

---@param url_fmt string
---@param min_ver Package.Version
---@param max_ver Package.Version
---@return Package.Version[]
function Package.find_versions(url_fmt, min_ver, max_ver)
    ---@type Package.Version[]
    local versions = {}

    for major = min_ver.major, max_ver.major do
        for minor = min_ver.minor, max_ver.minor do
            for patch = min_ver.patch, max_ver.patch do
                local url = url_fmt:format(major, minor, patch)
                local ok = https.request {
                    url = url,
                    method = "HEAD",
                }
                if ok then
                    print("Found version: " .. major .. "." .. minor .. "." .. patch .. " at " .. url)
                    versions[#versions + 1] = {
                        major = major,
                        minor = minor,
                        patch = patch,
                    }
                end
            end
        end
    end

    return versions
end

---@async
---@param url_fmt string
---@param min_ver Package.Version
---@param max_ver Package.Version
---@param out { result: Package.Version[] }
---@return thread
function Package.find_versions_async(url_fmt, min_ver, max_ver, out)
    return copas.addthread(function ()
        ---@type Package.Version[]
        local versions = {}

        for major = min_ver.major, max_ver.major do
            for minor = min_ver.minor, max_ver.minor do
                for patch = min_ver.patch, max_ver.patch do
                    local url = url_fmt:format(major, minor, patch)
                    local ok = copas.http.request {
                        url = url,
                        method = "HEAD",
                    }
                    if ok then
                        print("Found version: " .. major .. "." .. minor .. "." .. patch .. " at " .. url)
                        versions[#versions + 1] = {
                            major = major,
                            minor = minor,
                            patch = patch,
                        }
                    end
                end
            end
        end

        out.result = versions
    end)
end

---@return string
function Package:get_url() return self.url_format:format(self.version.major, self.version.minor, self.version.patch) end

function Package:__tostring()
    return "Package: " .. self.name .. " v" .. self.version.major .. "." .. self.version.minor .. "." ..
    self.version.patch
end

---@param to string
function Package:begin_download(to)
    local file = assert(io.open(to, "wb"))
    local ok, err, code = https.request {
        url = self:get_url(),
        sink = ltn12.sink.file(file),
    }
    if not ok then error(err .. "\nCode: " .. code) end

    file:close()
end

return Package
