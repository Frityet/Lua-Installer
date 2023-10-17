---@type nu
local gui = require("yue.gui")
local Luarocks = require("Package/Luarocks")
local Version = require("Package/Version")
local common = require("pages/common")

local pkg = Luarocks:create()

---@type luvit.http.ClientRequest[]
local reqs

local function ui()
    local container = gui.Container.create()

    ---@type Package.Version?
    local selected_luarocks_version = nil

    local lua_header = gui.Label.create("Select Luarocks version")
    -- lua_header:setfont(common.fonts.subheader)
    container:addchildview(lua_header)

    local fetching_text = gui.Label.create("Fetching versions...")
    container:addchildview(fetching_text)

    local fetching_prgb = gui.ProgressBar.create()
    container:addchildview(fetching_prgb)

    local picker = gui.Picker.create()
    picker:setstyle {
        height = 25,
        ["margin-top"] = 10,
    }

    reqs = pkg:fetch_versions (nil, function(version, checked, total)
            local percent = checked / total * 100
            fetching_text:settext(string.format("Fetching versions... %d/%d (%.2f%%)", checked, total, percent))
            fetching_prgb:setvalue(percent)
            --hide the progress bar when we're at 100
            if percent >= 100 then
                fetching_text:setvisible(false)
                fetching_prgb:setvisible(false)
            end

            picker:additem(tostring(version))

            ---@type Package.Version[]
            local vers = {}

            for _, v in ipairs(picker:getitems() --[[@as string[] ]]) do
                if v == "None" then goto next end
                vers[#vers+1] = Version:from_string(v)
                ::next::
            end

            table.sort(vers, function (a, b) return a > b end)

            picker:clear()

            for i, v in ipairs(vers) do
                picker:additem(tostring(v))
            end

            picker:additem("None")
        end
    )

    function picker:onselectionchange()
        local sel = picker:getselecteditem()
        if sel == "None" then selected_luarocks_version = nil; return; end
        selected_luarocks_version = Version:from_string(sel)
        print("Selected Luarocks version: " .. tostring(selected_luarocks_version))
    end

    container:addchildview(picker)

    return container
end

---@param to string
---@param progress nu.ProgressBar
local function download(to, progress)

end

---@param to string
local function install(to)

end

local function cleanup()
    for _, req in ipairs(reqs) do
        req:destroy()
    end
end

---@type Page
return {
    name = "Luarocks",
    ui = ui,
    on_download = download,
    on_install = install,
    on_cleanup = cleanup
}
