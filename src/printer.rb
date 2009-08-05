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
  
class Printer
  def initialize(target)
    @target = target
  end

  def normalize_title(title)
    if title == nil or title == ''
      "(Undefined)"
    else
      title
    end
  end

  def generate_date(date)
    minutes = 1 / (24.0 * 60.0)
    now = DateTime::now
    elapsed_minutes = ((now - date) / minutes).to_i
    elapsed_hours = ((now - date) / minutes / 60).round
    elapsed_days = (now - date).round
    elapsed_weeks = ((now - date) / 7.0).round
    
    case elapsed_minutes
      when 0 then "~1m"
      when 1..40 then "~#{elapsed_minutes}m"
      when 40..60 then "~1h"
      when 60..100 then "~1h"
      when 101..830 then "~#{elapsed_hours}h"
      when 830..10070 then "~#{elapsed_days}d"
      when 10070..43100 then "~#{elapsed_weeks}w"
    end
  end

  def list_char
    "*"
  end

  def print_list_entry(text)
    @target << "  #{list_char} #{text}"
  end

  def print_scrap_list_entry(scrap)
    print_list_entry("#{normalize_title(scrap.title)} (#{generate_date(scrap.modified_at)})")
  end
end
