CREATE TABLE sphinx_config (
  "key"         varchar(32) NOT NULL primary key,
  "value"       varchar(255) NOT NULL
);

GRANT ALL ON sphinx_config TO PUBLIC;

INSERT INTO sphinx_config ("key", "value") VALUES
  ('host', '127.0.0.1'),
  ('port', '9306'),
  ('username', ''),
  ('password', ''),
  ('prefix', ''), -- непонятно
  ('path', '/home/foo'); -- где вы положите pysphinx.py

CREATE TYPE pysphinx_result AS (id int, weight int, attr text[]);

CREATE OR REPLACE FUNCTION public.pysphinx_select(query text)
 RETURNS SETOF pysphinx_result
 LANGUAGE plpythonu
AS $code$
if not 'pysphinx' in GD:
    conf = {}
    for row in plpy.execute("select * from sphinx_config"):
        conf[row['key']] = row['value']
    if 'path' in conf: #'/path/to/module'
        from sys import path
        path.append( conf['path'] )
    from pysphinx import Pysphinx
    GD['pysphinx'] = Pysphinx(conf)
    plpu.notice('Persistent connection to sphinx make done')

GD['pysphinx'].query(query)
return GD['pysphinx'] # итерабельность
$code$
;