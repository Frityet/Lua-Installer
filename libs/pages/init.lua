---@class Page
---@field name string
---@field ui fun(): nu.Container
---@field on_download fun(to: string, progress_bar: nu.ProgressBar)
---@field on_install fun(to: string)
---@field on_cleanup fun() Invoked when the next page is loaded. Use this to stop any running requests

---@type Page[]
local pages = {
    require("pages/lua"),
    require("pages/luarocks"),
    require("pages/mingw")
}

return pages
