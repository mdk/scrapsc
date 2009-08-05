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

require 'rubygems'
require 'scrap'
require 'spec'
require 'date'

describe 'Scrap' do
  before(:each) do
    @s = Scrap::new
  end

  context 'scrap basic' do
    it "can be created" do
      @s.should_not be_nil
      @s.content.should == nil
    end

    it "has a settable content" do
      @s.content = "This is content"
      @s.content.should == "This is content"
    end
  
    it 'has a settable id' do
      @s.id = '1234S'
      @s.id.should == '1234S'
    end

    it 'has a setable creation date' do
      d = DateTime::now
      @s.created_at = d
      @s.created_at.should == d
    end
    
    it 'is fresh by default' do
      @s.fresh?.should be_true
    end

    it 'is not saved by default' do
      @s.saved?.should_not be_true
    end
  end
  
  context 'scrap serialization' do
    it "can be serialized to keys" do
      @s.content = "Hello"
      @s.id = 'AAA'
      @s.revision = '3'
      @s.title = "TitleOne"
      @s.nick = "nick"
    
      data = @s.to_db_keys

      data.should_not be_nil
      data['Content'].should == "Hello"
      data['Id'].should == "AAA"
      data['Revision'].should == "3"
      data['Title'].should == 'TitleOne'
      data['Nick'].should == 'nick'
    end

    it 'truly serializes to strings' do
      @s.revision = 3
    
      data = @s.to_db_keys
    
      data.should_not be_nil
      data['Revision'].should_not == 3
      data['Revision'].should == '3'
    end

    it "when serialized, nil is not put" do
      data = @s.to_db_keys
      data['Id'].should == ''
      data['Content'].should == ''
      data['Revision'].should == ''
    end

    it 'can unserialize from db keys' do
      data = { 'Id' => 'BBB', 
               'Revision' => '67', 
               'Content' => 'HelloWorld' }
      @s.from_db_keys('567', data)
  
      @s.local_id.should == '567'
      @s.id.should == 'BBB'
      @s.revision.should == '67'
      @s.content.should == 'HelloWorld'
    end
  end
end
