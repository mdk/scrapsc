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
  end

  def ListCommand::word
    'list'
  end
end
