---@type yue.gui
local gui = require("yue.gui")

---@class InputField : nu.View
local InputField = setmetatable({
    ---@type nu.Container
    container = nil,

    ---@type nu.Label
    label = nil,

    ---@type nu.Entry | nu.Picker
    input = nil,
}, { __index = gui.View })

---@param label string
---@param content nu.Entry | nu.Picker
---@return InputField
function InputField.create(label, content)
    ---@type InputField
    local self = setmetatable({}, InputField)

    --Place the 2 views next to each other
    self.container = gui.Container.create()
    self.container:setstyle {
        flex_direction = "row",
        align_items = "center",
        justify_content = "center",
        ["width-percent"] = 100,
        ["height-percent"] = 100,
    }

    self.label = gui.Label.create(label)
    self.label:setstyle {
        ["margin-right"] = 10,
        ["padding-top"] = 5,
        ["padding-bottom"] = 5,
    }
    self.input = content
    self.input:setstyle {
        ["padding-top"] = 5,
        ["padding-bottom"] = 5,
    }

    self.container:addchildview(self.label)
    self.container:addchildview(self.input)

    return self
end


