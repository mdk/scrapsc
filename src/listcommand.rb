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
      puts "  * #{scrap.local_id} - #{scrap.metadata.title}"
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
