Доброго всем

# pg-pysphinx

¡ ¡ ¡ ALL GLORY TO GLORIA ! ! !

# Description

Это тот самый случай, когда ради маленького ручейка данных городится монстрообразный многотонный мост.

Предполагается, что в запросе всегда первая колонка ID записи, т.е. запросы к сфинксу обязательно такие:

* ``` select * from <index> ... ```
* ``` select *, weight() from <index> ... ```
* ``` select id from <index> ...```

# Syntax

```sql 
select id, weight, attr from pysphinx_select("select ...")
```

```sql 
select id, weight, attr[0]::int from pysphinx_select("select ...")
```

# See also

https://github.com/Romamo/sphinxapi/

https://github.com/andy128k/pg-sphinx
