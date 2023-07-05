#!./lua

os.execute("./luarocks install --lua-version=5.1 --server=https://luarocks.org/dev combustion")

os.execute("./luarocks make")

os.execute("./lua_modules/bin/combust -S src lua_modules/share/lua/5.4/ -Llua_modules/lib/lua/5.4 --lua=/usr/local/bin/lua5.4 --name=\"lua-installer\" -v")
