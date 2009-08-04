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
    @tdb.each { |key, cols|
      s = Scrap::new
      s.from_db_keys(key, cols)
      yield s
    }
  end

  def find_first_by_matcher(matcher)
    find_all_by_matcher.first
  end

  def find_all_by_matcher(matcher)
    qry1 = TDBQRY::new(@tdb)
    qry1.addcond(nil, TDBQRY::QCSTRINC, matcher)  

    qry2 = TDBQRY::new(@tdb)
    qry2.addcond('metadata:NickName', TDBQRY::QCSTRINC, matcher)  

    qry3 = TDBQRY::new(@tdb)
    qry3.addcond('metadata:Title', TDBQRY::QCSTRINC, matcher)  

    qry1.metasearch([qry2, qry3], 0).each { |key|
      s = Scrap::new
      cols = @tdb.get(key)
      s.from_db_keys(key, cols)
      yield s
    }
  end
end
