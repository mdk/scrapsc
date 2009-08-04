class Metadata < Hash
  def title
    self['metadata:Title']
  end

  def title=(v)
    self['metadata:Title'] = v
  end

  def nick
    self['metadata:Nick']
  end

  def nick=(v)
    self['metadata:Nick'] = v
  end
end
