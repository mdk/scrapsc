require 'command'
require 'scrap'
require 'storage'

class FindCommand < Command
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
    if scrap
      puts "* #{scrap.local_id} - #{scrap.metadata.title}"
    end
    storage.close
  end

  def FindCommand::word
    'find'
  end

  def FindCommand::hint
    'find KEYWORD : list notes matching word (via id, nick or title)'
  end
end
