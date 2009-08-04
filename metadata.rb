require 'date'

class Metadata < Hash
  def title
    self['Title']
  end

  def title=(v)
    self['Title'] = v
  end

  def nick
    self['Nick']
  end

  def nick=(v)
    self['Nick'] = v
  end

  def created_at=(v)
    self['CreatedAt'] = v.to_s
  end

  def created_at
    self['CreatedAt']
  end

  def modified_at=(v)
    self['ModifiedAt'] = v.to_s
  end

  def modified_at
    self['ModifiedAt']
  end

  def set_dates
    date = DateTime::now
    self.created_at = date
    self.modified_at = date
  end
end
