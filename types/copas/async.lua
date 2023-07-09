---@meta

---@class copas.async
local async = {}

---@class copas.async.Future<T> : { try: (fun(): T | nil), get: (fun(): T) }
local Future = {}

---@generic T
---@param f fun(): T
---@return copas.async.Future<T>
function async.addthread(f) end
