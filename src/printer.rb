require 'date'
  
class Printer
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
      when 0..40 then "~#{elapsed_minutes}m"
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
end
