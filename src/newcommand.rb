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

require 'command'
require 'scrap'
require 'storage'
require 'tempfile'

class NewCommand < Command
  attr_reader :title

  def initialize(args)
    super(args)
    @title = nil
  end

  def walk!
    move_one_or_throw!('Scrap title is required.')
    @title = @current
    throw_if_any_left
  end

  def NewCommand::word
    'new'
  end

  def do!
    storage = Storage::new

    editor = ENV['EDITOR'] || 'vi'
    tempfile = Tempfile.new('scrap')
    system("#{editor} #{tempfile.path}")
    
    scrap = Scrap::new
    scrap.read_content(tempfile)
    if scrap.content != nil and scrap.content != ''
      scrap.title = @title
      storage << scrap
    else
      puts "No content, not saving."
    end

    storage.close
  end

  def NewCommand::hint
    'new TITLE    : create new note using text editor'
  end
end

