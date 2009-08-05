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

require 'printer'
require 'date'

describe "Printer" do
  before (:each) do
    @str = ''
    @p = Printer::new(@str)
  end

  context 'printer helpers' do
    it 'can normalize a title' do
      @p.normalize_title("This").should == "This"
      @p.normalize_title(nil).should == "(Undefined)"
      @p.normalize_title('').should == '(Undefined)'
    end

    it 'has a list char' do
      @p.list_char.should == "*"
    end

    it 'generates nice dates' do
      minute = 1.0 / (24 * 60.0)
      @p.generate_date(DateTime::now - (minute * 0.1)).should == "~1m"
      @p.generate_date(DateTime::now - (minute * 5)).should == "~5m"
      @p.generate_date(DateTime::now - (minute * 40)).should == "~40m"
      @p.generate_date(DateTime::now - (minute * 41)).should == "~1h"
      @p.generate_date(DateTime::now - (minute * 50)).should == "~1h"
      @p.generate_date(DateTime::now - (minute * 61)).should == "~1h"
      @p.generate_date(DateTime::now - (minute * 105)).should == "~2h"
      @p.generate_date(DateTime::now - (minute * 60 * 14)).should == "~1d"
      @p.generate_date(DateTime::now - 1).should == "~1d"
      @p.generate_date(DateTime::now - 5).should == "~5d"
      @p.generate_date(DateTime::now - 6).should == "~6d"
      @p.generate_date(DateTime::now - 7).should == "~1w"
      @p.generate_date(DateTime::now - 10).should == "~1w"
      @p.generate_date(DateTime::now - 11).should == "~2w"
      @p.generate_date(DateTime::now - 14).should == "~2w"
      @p.generate_date(DateTime::now - 18).should == "~3w"
    end
  end

  context 'print format' do
    it 'can print a list entry' do
      @p.print_list_entry("LALA")
      @str.should == '  * LALA'
    end

    it 'can print a scrap list entry' do
      scrap = mock('Scrap')
      scrap.stub!(:title).and_return('My Scrap')
      scrap.stub!(:modified_at).and_return(DateTime::now)
      @p.print_scrap_list_entry(scrap)
      @str.should == '  * My Scrap (~1m)'
    end

    it 'can print a scrap list entry with no title' do
      scrap = mock('Scrap')
      scrap.stub!(:title).and_return(nil)
      scrap.stub!(:modified_at).and_return(DateTime::now)
      @p.print_scrap_list_entry(scrap)
      @str.should == '  * (Undefined) (~1m)'
    end

    it 'can print a scrap list entry with empty title' do
      scrap = mock('Scrap')
      scrap.stub!(:title).and_return('')
      scrap.stub!(:modified_at).and_return(DateTime::now)
      @p.print_scrap_list_entry(scrap)
      @str.should == '  * (Undefined) (~1m)'
    end

    it 'can print a generic message' do
      @p.print_message('Saved.')
      @str.should == 'Saved.'
    end

    it 'can print an error message' do
      @p.print_error('Failed')
      @str.should == 'ERROR: Failed'
    end

    it 'can print a warning message' do
      @p.print_warning('Watch out!')
      @str.should == 'WARNING: Watch out!'
    end

    it 'can print a field value' do
      @p.print_field('Title', 'Hello')
      @str.should == 'Title: Hello'
    end

    it 'can print usage info' do
      @p.print_usage('new [NOTE TITLE]')
      @str.should == 'scrapsc new [NOTE TITLE]'
    end
  end
end
