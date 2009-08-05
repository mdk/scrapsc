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

class ListCommand < Command
  attr_reader :all

  def initialize(args)
    super(args)
    @all = false
  end

  def walk!
    move_one!
    if @current == '--all' or @current == '-a'
      @all = true
    elsif @current != nil
      throw "Unrecognized argument: #{@current}"
    end
  end

  def do!
    storage = Storage::new
    
    puts "Latest scraps:\n\n"
    storage.each { |scrap|
      puts "  * #{scrap.local_id} - #{scrap.title}"
    }

    storage.close
    puts "\n"
  end

  def ListCommand::word
    'list'
  end

  def ListCommand::hint
    'list [--all] : list recent or all scraps'
  end
end
