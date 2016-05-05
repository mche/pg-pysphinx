CREATE if not exists TABLE pllua.sphinx_config (
  "key"         varchar(32) NOT NULL primary key,
  "value"       varchar(255) NOT NULL
);

--GRANT ALL ON sphinx_config TO PUBLIC;

INSERT INTO pllua.sphinx_config ("key", "value") VALUES
  ('host', '127.0.0.1'),
  ('port', '9306'),
  ('path', '~/bar/?.lua;~/foo/?.lua'),
  ('cpath', '~/openresty/lualib/?.so')
;

-- update sphinx_config set value = '/home/foo/pg-pysphinx' where key='path';


CREATE TYPE pllua.sphinx_result AS (id int, attr text[], weight int);

CREATE OR REPLACE FUNCTION pllua.sphinx(query text)
 RETURNS SETOF pllua.sphinx_result
as $code$
if _U == nil then _U = {} end
if _U.sphinx == nil then
  local conf = {}
  local row = {}
  for row in server.rows('SELECT * FROM pllua.sphinx_config') do
      conf[row['key']] = row['value']
    end
  --print(package.cpath)
  local home = os.getenv('HOME')
  if conf.cpath and conf.cpath ~= "" then
    -- package.cpath = package.cpath .. ";" .. os.getenv('HOME') .. "/openresty/lualib/?.so"
    package.cpath = package.cpath .. ";" .. string.gsub(conf.cpath, "~", home)
  end
  if conf.path and conf.path ~= "" then
    package.path = package.path .. ";" .. string.gsub(conf.path, "~", home)
  end
  -- load driver
  local driver = require "luasql.mysql"
-- create environment object
  local env = assert (driver.mysql(), "Проблемы с драйвером mysql")
-- connect to data source
  _U.sphinx = assert (env:connect("",nil,nil,conf.host, conf.port), "Не смог соединиться к сфинксу")
  print("Соединился к сфинксу", _U.sphinx)
  
end

--local cjson = require "cjson"

-- retrieve a cursor
local cur = assert (_U.sphinx:execute("SELECT *,weight() FROM idx1 WHERE MATCH('алла') LIMIT 10"), "Ошибка запроса к индексу сфинкса")
--local row = {}
local row = cur:fetch ({}, "a")
while row do
  --print(cjson.encode(row))
  coroutine.yield{id=row.id, attr=nil, weight=(row['weight'] or row['weight()'])}
  row = cur:fetch (row, "a")-- reusing the table of results
end
--repeat
--  print(row)
--until row = cur:fetch (row, "a")
-- close everything
cur:close() -- already closed because all the result set was consumed
--con:close()
--env:close()
$code$ language plluau;
