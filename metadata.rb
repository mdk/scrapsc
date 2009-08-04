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
end
