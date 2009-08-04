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
    elapsed_hours = ((now - date) / minutes / 60).to_i
    
    case elapsed_minutes
      when 0..40 then "~#{elapsed_minutes}m"
      when 40..60 then "~1h"
      when 60..100 then "~1h"
      when 101..840 then "~#{elapsed_hours + 1}h"
    end
  end
end
