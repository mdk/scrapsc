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
    qry.setorder('metadata:ModifiedAt', TDBQRY::QOSTRDESC)
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
    qry.addcond(nil, TDBQRY::QCSTRINC, matcher)  
    key = qry.search.first
    return wrap_scrap(key) if key

    # Nick
    qry = TDBQRY::new(@tdb)
    qry.addcond('metadata:Nick', TDBQRY::QCSTRINC, matcher)  
    key = qry.search.first
    return wrap_scrap(key) if key

    # Title
    qry = TDBQRY::new(@tdb)
    qry.addcond('metadata:Title', TDBQRY::QCSTRINC, matcher)  
    key = qry.search.first
    return wrap_scrap(key) if key

    nil
  end

  def each_by_matcher(matcher)
    keys = []

    # By id
    qry = TDBQRY::new(@tdb)
    qry.addcond(nil, TDBQRY::QCSTRINC, matcher)  
    keys += qry.search

    # Nick
    qry = TDBQRY::new(@tdb)
    qry.addcond('metadata:Nick', TDBQRY::QCSTRINC, matcher)  
    keys += qry.search

    # Title
    qry = TDBQRY::new(@tdb)
    qry.addcond('metadata:Title', TDBQRY::QCSTRINC, matcher)  
    keys += qry.search
    
    keys.each { |key|
        yield wrap_scrap(key)
    }
  end
end
