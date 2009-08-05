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

class InfoCommand < Command
  attr_reader :all

  def initialize(args)
    super(args)
    @keyword = false
  end

  def walk!
    move_one!
    throw 'No find keyword specified' if not @current
    @keyword = @current
    throw_if_any_left
  end

  def do!
    storage = Storage::new
    scrap = storage.first_by_matcher(@keyword)
    throw 'Scrap not found' if not scrap

    puts "Title       : #{scrap.metadata.title}"
    puts "Created at  : #{scrap.metadata.created_at}"
    puts "Modified at : #{scrap.metadata.modified_at}"
    storage.close
  end

  def InfoCommand::word
    'info'
  end

  def InfoCommand::hint
    'info KEYWORD : show the info about the note matching keyword'
  end
end
