package("curl-pp")
do
    add_deps("cmake", "libcurl")
    set_urls("https://github.com/jpbarrette/curlpp/archive/refs/tags/v$(version).zip")

    add_versions("0.8.1", "67bb923bee565d1076baa6a758d299594ff0d8fd26fc5e02b83c5f5b5764ccee")

    on_install(function (package)
        import("package.tools.cmake").install(package, {"-DBUILD_SHARED_LIBS=OFF"}, { packagedeps = { "libcurl" } })
    end)
end
package_end()
