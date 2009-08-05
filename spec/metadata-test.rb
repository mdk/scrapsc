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

$LOAD_PATH << './src'

require 'metadata'
require 'date'

describe 'Metadata' do

  before(:each) do
    @m = Metadata::new
  end

  context 'basic metadata' do
    it 'can be created' do
      @m.should_not be_nil
    end
  end

  context 'metadata snips' do
    it 'has title' do
      @m['Title'].should == nil
      @m.title = "This is title"
      @m.title.should == 'This is title'
      @m['Title'].should == 'This is title'
    end

    it 'has nick' do
      @m['Nick'].should == nil
      @m.nick = "nnn"
      @m.nick.should == 'nnn'
      @m['Nick'].should == 'nnn'
    end
    
    it 'has a created at date' do
      date = DateTime::now
      @m['CreatedAt'].should == nil
      @m.created_at = date
      @m.created_at.should == date.to_s
      @m['CreatedAt'].should == date.to_s
    end

    it 'has a modified at date' do
      date = DateTime::now
      @m['ModifiedAt'].should == nil
      @m.modified_at = date
      @m.modified_at.should == date.to_s
      @m['ModifiedAt'].should == date.to_s
    end
  end

  context 'metadata helpers' do
    it 'can automatically set dates' do
      @m.modified_at.should be_nil
      @m.created_at.should be_nil
      @m.set_dates
      @m.modified_at.should_not be_nil
      @m.created_at.should_not be_nil
    end
  end
end
