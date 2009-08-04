require 'rubygems'

class OptWalker
  def initialize(args)
    @args = args
    @current = nil
    if self.cmd
      throw "Expected #{self.cmd}" if args.length == 0 or args[0] != self.cmd
    end
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

  def cmd
    nil
  end
end

class NewWalker < OptWalker
  attr_reader :title

  def initialize(args)
    super(args)
    move_one!
    @title = nil
  end

  def walk!
    move_one_or_throw!('Scrap title is required.')
    @title = @current
  end

  def cmd
    'new'
  end
end

class ListWalker < OptWalker
  attr_reader :all

  def initialize(args)
    super(args)
    move_one!
    @all = false
  end

  def walk!
    move_one!
    if @current == '--all' or @current == '-a'
      @all = true
    end
  end

  def cmd
    'list'
  end
end
