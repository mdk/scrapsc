require 'rubygems'

class OptWalker
  def initialize(args)
    @args = args
    @current = nil
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
end

class NewWalker < OptWalker

  attr_reader :title

  def initialize(args)
    super(args)
    move_one!
    throw 'Expected new' if @current != 'new'
    @title = nil
  end

  def walk!
    move_one_or_throw!('Scrap title is required.')
    @title = @current
  end
end
