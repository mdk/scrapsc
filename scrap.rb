require 'metadata'

class Scrap
  
  attr_reader :metadata
  attr_accessor :content, :local_id, :remote_id, :revision

  def initialize
    @metadata = Metadata::new
    @content = ''
    @local_id = nil
    @remote_id = nil
    @revision = 1
  end

  def to_db_keys
    hsh = {}
    hsh['content'] = @content
    hsh['remote_id'] = @remote_id.to_s
    hsh['revision'] = @revision.to_s

    # Metadata
    metadata.each { |key, value|
      name = "metadata:#{key}"
      hsh[name] = value
    }
    hsh
  end

  def from_db_keys(key, data)
    @content = data['content']
    @local_id = key
    @remote_id = data['remote_id']
    @revision = data['revision'].to_i

    # Metadata 
    data.each { |key, value| 
      if key =~ /^metadata:/
        @metadata[key.gsub(/^metadata:/, '')] = value
      end
    }
  end

  def read_content(f)
    @content = ''
    f.each_line { |line|
      @content << line
    }
  end

  def fresh?
    @remote_id == nil
  end

  def saved?
    @local_id != nil
  end

  def has_metadata?(m)
    @metadata[m] != nil
  end
end
