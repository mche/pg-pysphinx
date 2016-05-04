do $$
-- load driver
local driver = require "luasql.mysql"
-- create environment object
env = assert (driver.mysql())
-- connect to data source
con = assert (env:connect("",nil,nil,'127.0.0.1', 9306))
print(con)
$$ language plluau;
