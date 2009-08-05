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

  def write_content(f)
    f << @content
    f.flush
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
