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
require 'newcommand'
require 'spec'

describe 'NewCommand' do
    context 'basic new command' do
      it 'can be created' do
        @w = NewCommand::new(['new'])
        @w.should_not be_nil
      end

      it "can't be created with invalid word" do
        lambda {
          NewCommand::new(['save'])
        }.should raise_error
      end
    end

    context 'walking new command' do
      it 'can walk a set with title' do
        @w = NewCommand::new(['new', 'some title'])
        @w.walk!
        @w.title.should == 'some title'
      end

      it 'requires a valid title' do
        @w = NewCommand::new(['new'])
        lambda { @w.walk! }.should raise_error
      end
    end
end

