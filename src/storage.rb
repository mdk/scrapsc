# Copyright (c) 2009 New Wild. 
#
# Authors:
#   * Michael Dominic K. <mdk@new-wild.com>
#  
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#  
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#  
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'tokyocabinet'
require 'scrap'

include TokyoCabinet

class Storage

  def initialize(db = nil)
    @tdb = db
    if not @tdb
      @tdb = TDB::new
      @tdb.open(Scrap::database_path, TDB::OWRITER | TDB::OCREAT)
    end
  end

  def Scrap::database_path
    'scraps.tct'
  end

  def << (scrap)
    data = scrap.to_db_keys
    if scrap.saved?
      @tdb.put(scrap.local_id, data)
    else
      key = @tdb.genuid
      data = scrap.to_db_keys
      @tdb.put(key, data)
      scrap.local_id = key
    end
  end

  def close
    @tdb.close
  end

  def each 
    qry = TDBQRY::new(@tdb)
    qry.setorder('ModifiedAt', TDBQRY::QOSTRDESC)
    qry.search.each { |key|
      yield wrap_scrap(key)
    }
  end

  def wrap_scrap(key)
    s = Scrap::new
    cols = @tdb.get(key)
    s.from_db_keys(key, cols)
    s
  end

  def first_by_matcher(matcher)
    # By id
    qry = TDBQRY::new(@tdb)
    qry.addcond('', TDBQRY::QCSTREQ, matcher)  
    key = qry.search.first
    return wrap_scrap(key) if key

    # Nick
    qry = TDBQRY::new(@tdb)
    qry.addcond('Nick', TDBQRY::QCSTRINC, matcher)  
    key = qry.search.first
    return wrap_scrap(key) if key

    # Title
    qry = TDBQRY::new(@tdb)
    qry.addcond('Title', TDBQRY::QCSTRINC, matcher)  
    key = qry.search.first
    return wrap_scrap(key) if key
    nil
  end

  def each_by_matcher(matcher)
    keys = []

    # By id
    qry = TDBQRY::new(@tdb)
    qry.addcond('', TDBQRY::QCSTRINC, matcher)  
    keys += qry.search

    # Nick
    qry = TDBQRY::new(@tdb)
    qry.addcond('Nick', TDBQRY::QCSTRINC, matcher)  
    keys += qry.search

    # Title
    qry = TDBQRY::new(@tdb)
    qry.addcond('Title', TDBQRY::QCSTRINC, matcher)  
    keys += qry.search
    
    keys.each { |key|
        yield wrap_scrap(key)
    }
  end
end
