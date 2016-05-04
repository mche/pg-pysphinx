do $$
if _U == nil then _U = {} end
if _U.sphinx == nil then
  local conf = {}
  local row = {}
  for row in server.rows('SELECT * FROM sphinx_config') do
      conf[row['key']] = row['value']
    end
  -- load driver
  local driver = require "luasql.mysql"
-- create environment object
  local env = assert (driver.mysql(), "Проблемы с драйвером mysql")
-- connect to data source
  _U.sphinx = assert (env:connect("",nil,nil,conf.host, conf.port), "Не смог соединиться к сфинксу")
  print("Соединился к сфинксу", _U.sphinx)
  --print(package.cpath)
  package.cpath = package.cpath .. ";" .. os.getenv('HOME') .. "/openresty/lualib/?.so"
end

local cjson = require "cjson"

-- retrieve a cursor
local cur = assert (_U.sphinx:execute("SELECT *,weight() FROM idx1 WHERE MATCH('алла') LIMIT 10"), "Ошибка запроса к индексу сфинкса")
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
--con:close()
--env:close()
$$ language plluau;
