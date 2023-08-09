includes("../libLuaInstaller")

local packages = {
    "curlpp-local"
}

local sanitizers = { "address", "leak", "undefined" }

local cxxflags = {
    release = {},
    debug = {
        "-Wno-unused-function", "-Wno-unused-parameter", "-Wno-unused-variable"
    },
    regular = {
        "-Wno-deprecated-enum-enum-conversion",
        "-fcoroutines",
        "-frtti",
    }
}


if is_plat("windows") then
    cxxflags.regular[#cxxflags.regular + 1] = "-FS"
else
    cxxflags.regular[#cxxflags.regular + 1] = "-Wall"
    cxxflags.regular[#cxxflags.regular + 1] = "-Wextra"
    cxxflags.regular[#cxxflags.regular + 1] = "-Werror"
end

local ldflags = {
    release = {},
    debug = {},
    regular = {}
}

set_languages("cxxlatest")

add_rules("mode.debug", "mode.release")

add_requires(packages, { system = false, configs = { shared = true } })

target "CLI" do
    set_kind("binary")
    add_packages(packages)
    add_files("src/**.cpp")
    add_headerfiles("src/**.hpp")
    add_includedirs("src/")
    add_deps("LuaInstaller")
    add_cxxflags(cxxflags.regular)
    add_ldflags(ldflags.regular)
    add_defines("_CRT_SECURE_NO_WARNINGS")

    if is_mode "debug" then
        add_cxxflags(cxxflags.debug)
        add_ldflags(ldflags.debug)

        for _, v in ipairs(sanitizers) do
            add_cxflags("-fsanitize=" .. v)
            add_ldflags("-fsanitize=" .. v)
        end

        add_defines("PROJECT_DEBUG")
    else
        add_cxxflags(cxxflags.release)
        add_ldflags(ldflags.release)
    end
end
