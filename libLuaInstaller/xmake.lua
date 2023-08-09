local packages = {
}

option "vcpkg-curlpp" do
    set_default(false)
    set_showmenu(true)
    set_category("option")
    set_description("Use vcpkg curlpp")
end
option_end()

if has_config("vcpkg-curlpp") then
    packages[#packages+1] = "vcpkg::curlpp"
else
    package "curlpp-local" do
        add_deps("cmake")
        add_deps("libcurl", { configs = { shared = false } })
        set_urls("https://github.com/jpbarrette/curlpp/archive/refs/tags/v$(version).zip")

        add_versions("0.8.1", "67bb923bee565d1076baa6a758d299594ff0d8fd26fc5e02b83c5f5b5764ccee")

        on_install(function(package)
            local lcurl = package:dep("libcurl")

            import("package.tools.cmake").install(package, {
                "-DCURLPP_BUILD_SHARED_LIBS="..(package:config("shared") and "ON" or "OFF"),
                "-DBUILD_SHARED_LIBS="..(package:config("shared") and "ON" or "OFF"),
                "-DCURLPP_STATIC_CRT=ON",
                "-DCURL_INCLUDE_DIRS=" .. lcurl:installdir("include"),
                "-DCURL_LIBRARIES=" .. lcurl:installdir("lib", "libcurl.a"),

            }, { packagedeps = { "libcurl" } })
        end)
    end
    package_end()

    packages[#packages+1] = "curlpp-local"
end

local sanitizers = { }

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

target "LuaInstaller" do
    set_kind("static")
    add_packages(packages)
    add_files("src/**.cpp")
    add_headerfiles("src/**.hpp")
    add_includedirs("src/", { public = true })
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
