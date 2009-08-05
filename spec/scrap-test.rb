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

describe 'Scrap' do

  before(:each) do
    @s = Scrap::new
  end

  context 'scrap basic' do

    it "can be created" do
      @s.should_not be_nil
    end

    it "has a settable content" do
      @s.content = "This is content"
      @s.content.should == "This is content"
    end

    it "has a settable metadata" do
      @s.metadata['Title'] = "TitleOne"
      @s.metadata['Nick'] = "nick"
      @s.metadata['Title'].should == "TitleOne"
      @s.metadata['Nick'].should == "nick"
    end

    it 'is fresh by default' do
      @s.fresh?.should be_true
    end

    it 'is not saved by default' do
      @s.saved?.should_not be_true
    end

    it "can be serialized to keys" do
      @s.content = "Hello"
      @s.remote_id = 'AAA'
      @s.revision = 3
      @s.metadata['Title'] = "TitleOne"
      @s.metadata['Nick'] = "nick"
    
      data = @s.to_db_keys

      data.should_not be_nil
      data['content'].should == "Hello"
      data['remote_id'].should == "AAA"
      data['revision'].should == "3"
      data['metadata:Title'].should == 'TitleOne'
      data['metadata:Nick'].should == 'nick'
    end
  end

  context 'scrap serialization' do

    it 'truly serializes to strings' do
      @s.revision = 3
    
      data = @s.to_db_keys
    
      data.should_not be_nil
      data['revision'].should_not == 3
    end

    it "when serialized, nil is not put" do
      data = @s.to_db_keys
      data['remote_id'].should == ''
      data['content'].should == ''
      data['revision'].should == '1'
    end

    it 'can unserialize from db keys' do
      data = { 'remote_id' => 'BBB', 
               'revision' => '67', 
               'content' => 'HelloWorld' }
      @s.from_db_keys('567', data)
  
      @s.local_id.should == '567'
      @s.remote_id.should == 'BBB'
      @s.revision.should == 67
      @s.content.should == 'HelloWorld'
    end

    it 'can unserialize metadata too' do
      data = { 'remote_id' => 'CCC', 
               'revision' => '87', 
               'content' => 'HelloWorld', 
               'metadata:Title' => 'Hello', 
               'metadata:Another' => 'Another' }
      @s.from_db_keys('666', data)
    
      @s.local_id.should == '666'
      @s.remote_id.should == 'CCC'
      @s.revision.should == 87
      @s.content.should == 'HelloWorld'
      @s.metadata['Title'].should == 'Hello'
      @s.metadata['Another'].should == 'Another'
    end
  end
end
