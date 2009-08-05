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
require 'tokyocabinet'
require 'storage'
require 'spec'

include TokyoCabinet

describe 'Storage' do

  before(:each) do
    @db = TDB::new
    @db.open('test.tct', TDB::OWRITER | TDB::OCREAT)
    @db.vanish
    @st = Storage::new(@db)
  end

  context 'storage basic' do

    it 'can be created' do
      @st.should_not be_nil
    end

    it 'can save a non-saved scrap' do
      scrap = mock('Scrap')
      scrap.stub!(:saved?).and_return(false)
      scrap.stub!(:to_db_keys).and_return({'content' => 'Content', 'something' => 'Something'})
      scrap.should_receive(:local_id=).once
      @st << scrap
    end

    it 'can save a saved scrap' do
      scrap = mock('Scrap')
      scrap.stub!(:saved?).and_return(true)
      scrap.stub!(:local_id).and_return(666)
      scrap.stub!(:to_db_keys).and_return({'content' => 'Content'})
      scrap.should_not_receive(:local_id=)
      @st << scrap
      scrap.local_id.should == 666
      @db.get('666')['content'].should == 'Content'
    end
  end

  after(:each) do
    @st.close
  end
end

