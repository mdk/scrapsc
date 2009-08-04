require 'command'
require 'scrap'
require 'storage'

class InfoCommand < Command
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
    throw 'Scrap not found' if not scrap

    puts "Title       : #{scrap.metadata.title}"
    puts "Created at  : #{scrap.metadata.created_at}"
    puts "Modified at : #{scrap.metadata.modified_at}"
    storage.close
  end

  def InfoCommand::word
    'info'
  end

  def InfoCommand::hint
    'info KEYWORD : show the info about the note matching keyword'
  end
end
