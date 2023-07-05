---@type yue.gui
local gui = require("yue.gui")

local window = gui.Window.create {}

window:settitle "Lua installer"
function window:onclose()
    gui.MessageLoop.quit()
end

local container = gui.Container.create()
container:setstyle {
    ["flex-direction"]  = "column",
    ["justify-content"] = "center",
    ["align-items"]     = "center",
    ["flex"]            = 1,
    ["padding"]         = 10,
}


gui.MessageLoop.run()
