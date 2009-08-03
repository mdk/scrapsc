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
    qry = TDBQRY::new(@tdb)
    qry.addcond(nil, TDBQRY::QCSTREQ, matcher)  
    qry.addcond('metadata:NickName', TDBQRY::QCSTREQ, matcher)  
    qry.addcond('metadata:Title', TDBQRY::QCSTREQ, matcher)  
    qry.setlimit(1)
    qry.search
  end
end
