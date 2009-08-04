class Command
  def initialize(args)
    @current = nil
    @args = args
    if self.class::word
      throw "Expected #{self.class::word}" if @args.length == 0 or @args[0] != self.class::word
    end
    move_one!
  end

  def move_one!
    @current = @args.first
    return false if not @current
    @args.delete_at(0)
  end
  
  def move_one_or_throw!(msg)
    move_one!
    throw msg if not @current
  end

  def throw_if_any_left
    throw 'Too many arguments' if @args.length > 0  
  end

  def Command::word
    nil
  end
end
