---@meta

---@class ssl.https
local https = {}

---@alias ssl.https.Method
---| "GET"\
---| "POST"
---| "HEAD"
---| "PUT"
---| "DELETE"
---| "OPTIONS"
---| "TRACE"
---| "CONNECT"

---@class ssl.https.Request
---@field url string
---@field method ssl.https.Method
---@field headers { [string] : string }
---@field sink ltn12.Sink
---@field proxy string
---@field redirect boolean

---@overload fun(url: string, method: ssl.https.Method, headers: { [string] : string }, sink: ltn12.Sink, proxy: string, redirect: boolean): string?, string?, number
---@param request ssl.https.Request
---@return string?, string?, number
function https.request(request) end
