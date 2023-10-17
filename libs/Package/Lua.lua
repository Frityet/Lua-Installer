local Package = require("Package")
local https = require("https")
local url = require("url")
local fs = require("fs")

local htmlparser = require("htmlparser")

---@class Package.Lua : Package
local Lua = {
    url_format = "https://www.lua.org/ftp/lua-%d.%d.%d.tar.gz"
}
Lua.__index = Lua
Lua.__name = "Lua"
setmetatable(Lua, Package)

---@return Package.Lua
function Lua:create()
    return Package.create(self) --[[@as Package.Lua]]
end

---@param on_request fun(url: url_parsed)?
---@param on_get fun(ver: Package.Version?, checked: integer, total: integer)?
---@return { [1] : luvit.http.ClientRequest }
function Lua:fetch_versions(on_request, on_get)
    -- local reqs = {}
    -- reqs[1] = https.get("https://www.lua.org/ftp", function(res)
    --     if on_request then on_request(url.parse("https://www.lua.org/ftp")) end
    --     local loc = res.headers["location"] or res.headers["Location"]
    --     if not loc then error("Location " .. loc .. " not found") end

    --     reqs[1] = https.get(loc, function(res)
    --         if on_request then on_request(url.parse(loc)) end

    --         local data = ""
    --         local siz = tonumber(res.headers["content-length"] or res.headers["Content-Length"])
    --         res:on("error", error)
    --         res:on("data", function(chunk)
    --             data = data .. chunk
    --         end)

    --         res:on("end", function()
    --             local root = htmlparser.parse(data)
    --             --find the first <TABLE> in the <BODY> tag, the `select` function takes in a jquery selector
    --             local table = root:select("HTML")[1]:select("BODY")[1]:select("TABLE")[1]

    --             --Example of a table row
    --             --[[
    --             <TR>
    --                 <TD CLASS="name"><A HREF="lua-5.4.6.tar.gz">lua-5.4.6.tar.gz</A></TD>
    --                 <TD CLASS="date">2023-05-02</TD>
    --                 <TD CLASS="size">363329</TD>
    --                 <TD CLASS="sum">7d5ea1b9cb6aa0b59ca3dde1c6adcb57ef83a1ba8e5432c0ecd06bf439b3ad88</TD>
    --             </TR>

    --             ]]

    --             ---convert the table to a lua table
    --             ---@private
    --             ---@class LuaHTML.File
    --             ---@field filename string
    --             ---@field date string
    --             ---@field size integer
    --             ---@field sum string

    --             ---@type LuaHTML.File[]
    --             local entries = {}


    --             for i, row in ipairs(table) do
    --                 print(string.format("Entry %d tagname: %s", i, row.name))
    --                 for j, td in ipairs(row) do
    --                     print(string.format("Entry %d tagname: %s", j, td.name))
    --                     if td.name == "TH" then goto next_row end

    --                     entries[#entries+1] = {
    --                         filename = td[1][1].raw,
    --                         date = td[2][1].raw,
    --                         size = tonumber(td[3][1].raw) or 0,
    --                         sum = td[4][1].raw
    --                     }
    --                 end

    --                 ::next_row::
    --             end

    --             p(entries)
    --         end)
    --     end)
    -- end)

    -- reqs[1]:flushHeaders()
    -- reqs[1]:done()
    -- return reqs

    return Package.fetch_versions(self, { 5, 1, 0 }, { 5, 10, 10 }, on_request, on_get)
end

return Lua
