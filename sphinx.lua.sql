do $$
print(package.cpath)
package.cpath = package.cpath .. ";" .. os.getenv('HOME') .. "/openresty/lualib/?.so"
local cjson = require "cjson"
-- load driver
local driver = require "luasql.mysql"
-- create environment object
local env = assert (driver.mysql())
-- connect to data source
local con = assert (env:connect("",nil,nil,'127.0.0.1', 9306))
--print(con)
-- retrieve a cursor
local cur = assert (con:execute("SELECT *,weight() FROM idx1 WHERE MATCH('алла') LIMIT 10"))
--local row = {}
local row = cur:fetch ({}, "a")
while row do
  row['бар']={1,2,3}
  print(cjson.encode(row))
  -- reusing the table of results
  row = cur:fetch (row, "a")
end
--repeat
--  print(row)
--until row = cur:fetch (row, "a")
-- close everything
cur:close() -- already closed because all the result set was consumed
con:close()
env:close()
$$ language plluau;
