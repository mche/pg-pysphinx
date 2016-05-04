do $$
-- load driver
local driver = require "luasql.mysql"
-- create environment object
env = assert (driver.mysql())
-- connect to data source
con = assert (env:connect())
print con
$$ language plluau;
