---@type copas
local copas = require("copas")
---@type copas.async
local async = require("copas.async")
---@type yue.gui
local gui = require("yue.gui")

local packages = require("packages")

local lua_vers = async.addthread(packages.Lua.find_versions)

copas.addthread(function ()
    local win = gui.Window.create {}
    function win:onclose() gui.MessageLoop.quit() end
    win:settitle("Lua Installer")
    local contents = gui.Container.create()
    contents:setstyle {
        ["flex-direction"] = "column",
        ["justify-content"] = "center",
        ["align-items"] = "center",
        ["padding-top"] = 25,
        ["padding-bottom"] = 25,
        ["padding-left"] = 25,
        ["padding-right"] = 25,
    }
    do
        local label = gui.Label.create("Lua Versions")
        label:setstyle {
            ["margin-bottom"] = 10,
        }
        contents:addchildview(label)

        local select = gui.Picker.create()
        select:setstyle {
            ["width"] = 200,
            ["margin-bottom"] = 10,
        }
        function select:onmousedown()
            local vers = lua_vers:try()
            if vers then
                for _, v in ipairs(vers) do
                    select:additem(tostring(v))
                end

                return true
            end

            local alert = gui.MessageBox.create()
            alert:settext("Awaiting lua versions...")
            alert:runforwindow(win)

            vers = lua_vers:get()
            for _, v in ipairs(vers) do
                select:additem(tostring(v))
            end

            return true
        end

        contents:addchildview(select)
    end
    win:setcontentview(contents)
    win:setcontentsize(contents:getpreferredsize())
    win:center()
    win:setvisible(true)

    gui.MessageLoop.run()
end)

copas.loop()
