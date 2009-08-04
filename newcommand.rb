require 'command'
require 'scrap'
require 'storage'
require 'tempfile'

class NewCommand < Command
  attr_reader :title

  def initialize(args)
    super(args)
    @title = nil
  end

  def walk!
    move_one_or_throw!('Scrap title is required.')
    @title = @current
    throw_if_any_left
  end

  def NewCommand::word
    'new'
  end

  def do!
    storage = Storage::new

    editor = ENV['EDITOR'] || 'vi'
    tempfile = Tempfile.new('scrap')
    system("#{editor} #{tempfile.path}")
    
    scrap = Scrap::new
    scrap.read_content(tempfile)
    scrap.metadata.set_dates
    scrap.metadata.title = @title
    storage << scrap

    storage.close
  end

  def NewCommand::hint
    'new TITLE    : create new note using text editor'
  end
end

