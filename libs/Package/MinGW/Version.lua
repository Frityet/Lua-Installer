local Version = require("Package/Version")

---@class Package.MinGW.Version : Package.Version
local MinGWVersion = {
    ---@type integer
    runtime = 0,
    ---@type integer
    revision = 0
}
MinGWVersion.__index = MinGWVersion
MinGWVersion.__name = "MinGW.Version"
setmetatable(MinGWVersion, Version)

---@param major integer
---@param minor integer
---@param build integer
---@param runtime integer
---@param revision integer
---@return Package.MinGW.Version
function MinGWVersion:create(major, minor, build, runtime, revision)
    return setmetatable({
        major = major,
        minor = minor,
        build = build,
        runtime = runtime,
        revision = revision
    }, self)
end

---@param string string
---@return Package.MinGW.Version? ok, string? error
function MinGWVersion:from_string(string)
    local major_str, minor_str, build_str, runtime_str, revision_str = string:match("(%d+)%.(%d+)%.(%d+)-rt_v(%d+)-rev(%d+)")
    local major, minor, build, runtime, revision = tonumber(major_str), tonumber(minor_str), tonumber(build_str), tonumber(runtime_str), tonumber(revision_str)
    if not major or not minor or not build or not runtime or not revision then return nil, "Invalid version string" end

    return self:create(major, minor, build, runtime, revision), nil
end

---@param exmode "posix" | "win32"
---@param runtime "ucrt" | "msvcrt"
---@return string
function MinGWVersion:url(exmode, runtime, exceptionfmt)
    local base = "https://github.com/niXman/mingw-builds-binaries/releases/download/"..tostring(self)
    return (base.."/x86_64-%d.%d.%d-release-%s-seh-%s-rt_v%d-rev%d.7z"):format(self.major, self.minor, self.build, exmode, runtime, self.runtime, self.revision)
end

function MinGWVersion:__tostring()
    return ("%d.%d.%d-rt_v%d-rev%d"):format(self.major, self.minor, self.build, self.runtime, self.revision)
end

function MinGWVersion:__eq(other)
    return self.major == other.major and self.minor == other.minor and self.build == other.build and self.runtime == other.runtime and self.revision == other.revision
end

function MinGWVersion:__lt(other)
    if self.major ~= other.major then
        return self.major < other.major
    elseif self.minor ~= other.minor then
        return self.minor < other.minor
    elseif self.build ~= other.build then
        return self.build < other.build
    elseif self.runtime ~= other.runtime then
        return self.runtime < other.runtime
    else
        return self.revision < other.revision
    end
end

function MinGWVersion:__le(other)
    if self.major ~= other.major then
        return self.major < other.major
    elseif self.minor ~= other.minor then
        return self.minor < other.minor
    elseif self.build ~= other.build then
        return self.build < other.build
    elseif self.runtime ~= other.runtime then
        return self.runtime < other.runtime
    else
        return self.revision <= other.revision
    end
end

function MinGWVersion:__gt(other)
    if self.major ~= other.major then
        return self.major > other.major
    elseif self.minor ~= other.minor then
        return self.minor > other.minor
    elseif self.build ~= other.build then
        return self.build > other.build
    elseif self.runtime ~= other.runtime then
        return self.runtime > other.runtime
    else
        return self.revision > other.revision
    end
end

function MinGWVersion:__ge(other)
    if self.major ~= other.major then
        return self.major > other.major
    elseif self.minor ~= other.minor then
        return self.minor > other.minor
    elseif self.build ~= other.build then
        return self.build > other.build
    elseif self.runtime ~= other.runtime then
        return self.runtime > other.runtime
    else
        return self.revision >= other.revision
    end
end

return MinGWVersion
