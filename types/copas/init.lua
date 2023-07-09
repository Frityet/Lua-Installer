---@meta

---@class copas
local copas = {}

---@param fn async fun()
---@return thread
function copas.addthread(fn) end

function copas.loop() end

---@class copas.http
copas.http = {}

---@overload fun(url: string, method: ssl.https.Method, headers: { [string] : string }, sink: ltn12.Sink, proxy: string, redirect: boolean): string?, string?, number
---@param request ssl.https.Request
---@return string?, string?, number
function copas.http.request(request) end

