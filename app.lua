local Version = require "Package/Version"
package.path = "lua_modules/share/lua/5.1/?.lua;lua_modules/share/lua/5.1/?/init.lua;"..package.path
package.cpath = "lua_modules/lib/lua/5.1/?.so;"..package.cpath

local uv = require("uv")
local timer = require("timer")

---@type nu
local gui = require("yue.gui")

local l_error = error
function _G.error(msg, num)
    uv.stop()

    local msgbox = gui.MessageBox.create()
    msgbox:settype("error")
    msgbox:addbutton("Quit", 0)
    msgbox:setdefaultresponse(0)
    if jit.os ~= "OSX" then msgbox:settitle("Error") end
    msgbox:settext("An error has occured")
    msgbox:setinformativetext(debug.traceback(msg))
    msgbox:run()

    return l_error(msg, num)
end

local pages = require("pages")

local window = gui.Window.create {
    frame = true,
    transparent = false,
    showtrafficlights = true,
}
window:settitle "Lua Installer"

function window:onclose()
    uv.stop()
    gui.MessageLoop.quit()
    os.exit(0)
end


local container = gui.Container.create()
container:setstyle {
    padding = 15,
    --set min size
    ["min-width"] = 400,
    ["min-height"] = 300,
}

local selected_page_idx, selected_page = next(pages)

local page_container = gui.Container.create()
page_container:setstyle {
    -- ["flex-direction"] = "row",
    -- ["justify-content"] = "space-between",
    -- ["align-items"] = "center",
    -- ["margin-bottom"] = 10,
    ["padding"] = 10,

    --fill the container
    ["flex-grow"] = 1,
}

page_container:addchildview(selected_page.ui())

container:addchildview(page_container)

local next_button = gui.Button.create("Next")
---keep this button flexed to the bottom right
next_button:setstyle {
    ["justify-content"] = "flex-end",
    ["align-items"] = "flex-end"
}
container:addchildview(next_button)

function next_button:onclick()
    local next_page_idx, next_page = next(pages, selected_page_idx)
    if next_page then
        selected_page:on_cleanup()
        selected_page_idx, selected_page = next_page_idx, next_page

        local view = page_container:childat(1)
        view:setvisible(false)
        page_container:removechildview(view)
        page_container:addchildview(selected_page.ui())
        next_button:setvisible(false)

        next_page_idx, next_page = next(pages, selected_page_idx)
        if next_page then
            next_button:setvisible(true)
        end
    else
        window:close()
    end
end


window:setcontentview(container)
window:setcontentsize(container:getpreferredsize())

---@diagnostic disable-next-line: missing-fields
window:setsizeconstraints(container:getpreferredsize(), container:getpreferredsize())
window:center()
window:activate()

--runs when the event loop is ready
timer.setTimeout(0, function()
    uv.stop()

    -- utilities.enqueue(function()
    --     uv.run("nowait")
    --     return true
    -- end, 0.5)

    gui.MessageLoop.settimer(50, function ()
        uv.run("nowait")
        return true
    end)
    gui.MessageLoop.run()
end)
