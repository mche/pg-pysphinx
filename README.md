Доброго всем

# pg-pysphinx

¡ ¡ ¡ ALL GLORY TO GLORIA ! ! !

# Description

Это тот самый случай, когда ради маленького ручейка данных городится монстрообразный многотонный мост.

Предполагается, что в запросе всегда первая колонка ID записи, т.е. запросы обязательно такие:

* ```sql select * from <index> ... ```
* ```sql select *, weight() from <index> ... ```
* ```sql select id from <index> ...```

```sql 
select id, weight, attr from pysphinx_select("select ...")
```

# See also

https://github.com/Romamo/sphinxapi/

https://github.com/andy128k/pg-sphinx
