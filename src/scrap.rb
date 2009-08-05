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

require 'date'

class Scrap
  
  attr_accessor :content, :id, :revision, :title, :nick, :created_at, :modified_at
  attr_accessor :local_id

  def initialize
    @content = nil
    @local_id = nil
    @id = nil
    @revision = nil
    @title = nil
    @nick = nil
    @created_at = DateTime::now
    @modified_at = @created_at
  end

  def to_db_keys
    {'Content' => @content.to_s, 
     'Id' => @id.to_s,
     'Revision' => @revision.to_s,
     'Nick' => @nick.to_s, 
     'CreatedAt' => @created_at.to_s,
     'ModifiedAt' => @modified_at.to_s,
     'Title' => @title.to_s} 
  end

  def from_db_keys(key, data)
    @content = data['Content']
    @local_id = key
    @id = data['Id']
    @revision = data['Revision']
    @title = data['Title']
    @nick = data['Nick']
    @created_at = DateTime.parse(data['CreatedAt'])
    @modified_at = DateTime.parse(data['ModifiedAt'])
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
    @id == nil or @id == ''
  end

  def saved?
    @local_id != nil and @local_id != ''
  end
end
