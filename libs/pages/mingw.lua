---@type nu
local gui = require("yue.gui")
local Version = require("Package/MinGW/Version")
local MinGW = require("Package/MinGW")

local pkg = MinGW:create()

---@type luvit.http.ClientRequest
local req

local function ui()
    local container = gui.Container.create()
    do
        container:addchildview(gui.Label.create("Select MinGW version"))

        ---@type nu.Picker
        local type_picker
        local type_container = gui.Container.create()
        type_container:setstyle {
            ["margin-top"] = 10,
            --align horizontally
            ["flex-direction"] = "row",
            ["justify-content"] = "space-between",
        }
        do
            type_container:addchildview(gui.Label.create("Type:"))
            type_picker = gui.Picker.create()
            type_picker:setstyle {
                height = 25,
                ["margin-left"] = 10,
                width = 100,
            }
            type_picker:additem("Select type")
            for _, v in ipairs(MinGW.TYPES) do type_picker:additem(v) end
            type_container:addchildview(type_picker)
        end

        container:addchildview(type_container)

        local fetching_text = gui.Label.create("Fetching versions...")
        container:addchildview(fetching_text)

        local picker = gui.Picker.create()
        picker:setstyle {
            height = 25,
            ["margin-top"] = 10,
        }
        container:addchildview(picker)

        function type_picker:onselectionchange()
            local sel = self:getselecteditem()
            picker:clear()
            if sel == "Select type" then return end

            fetching_text:setvisible(true)
            req = pkg:fetch_versions(sel, function(version, checked, total)
                fetching_text:setvisible(false)

                picker:additem(tostring(version))

                ---@type Package.Version[]
                local vers = {}

                for _, v in ipairs(picker:getitems() --[[ @as string[] ]]) do
                    if v == "None" then goto next end
                    vers[#vers+1] = getmetatable(version).__index:from_string(v)
                    ::next::
                end

                table.sort(vers, function (a, b) return a > b end)

                picker:clear()

                for i, v in ipairs(vers) do
                    picker:additem(tostring(v))
                end

                picker:additem("None")
            end)
        end
    end
    return container
end

local function download(to, progress_bar)

end

local function install(to)

end

local function cleanup()
    req:destroy()
end

---@type Page
return {
    name = "mingw",
    ui = ui,

    on_download = download,
    on_install = install,
    on_cleanup = cleanup
}
