# -*- coding: utf-8 -*-
from __future__ import unicode_literals

class Pysphinx:
  '''
  SELECT *,weight() as  FROM idx1 WHERE MATCH('алла') LIMIT 10
  '''
  def __init__(self, conf):
    import pymysql
    self.conn = pymysql.connect( host=conf['host'], port=conf['port'], user=conf['username'], passwd=conf['password'], charset='utf8', db='')
    self.curs = self.conn.cursor()
    self.conf = conf
    
  def query(self, query):
    self.curs.execute(query)
    
    
    
  def __iter__(self):# итерабельность
    return self
    
    
  def next(self):# итерабельность
    row = self.curs.fetchone
    if not row:
      raise StopIteration
    if 'id' in row: id = row.pop("id", None)
    if 'weight' in row: weight = row.pop("weight", None)
    attr = [str(x) for x in row.itervalues]
    if attr == []: attr = None
    return (id, weight, attr)


########################################





#~ Iterator (any object providing __iter__ and next methods)
#~ CREATE FUNCTION greet (how text)
  #~ RETURNS SETOF greeting
#~ AS $$
  #~ class producer:
    #~ def __init__ (self, how, who):
      #~ self.how = how
      #~ self.who = who
      #~ self.ndx = -1

    #~ def __iter__ (self):
      #~ return self

    #~ def next (self):
      #~ self.ndx += 1
      #~ if self.ndx == len(self.who):
        #~ raise StopIteration
      #~ return ( self.how, self.who[self.ndx] )

  #~ return producer(how, [ "World", "PostgreSQL", "PL/Python" ])
#~ $$ LANGUAGE plpythonu;


