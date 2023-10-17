local profile = require("jit.p")

local function main()
    local ok, err = pcall(require, "./app")
    if not ok then error(err) end
end


return require('luvit')(function (...)
    if os.getenv("PROFILE") == "1" then
        profile.start("f3svza", "profile.log")
    end
    local ret = main()

    if os.getenv("PROFILE") == "1" then
        profile.stop()
    end

    return ret
end, ...)
