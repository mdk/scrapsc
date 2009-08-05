require 'command'
require 'scrap'
require 'storage'

class ShowCommand < Command
  attr_reader :all

  def initialize(args)
    super(args)
    @keyword = false
  end

  def walk!
    move_one!
    throw 'No scrap keyword specified' if not @current
    @keyword = @current
    throw_if_any_left
  end

  def do!
    storage = Storage::new
    scrap = storage.first_by_matcher(@keyword)
    throw 'Scrap not found' if not scrap

    editor = ENV['EDITOR'] || 'vi'
    tempfile = Tempfile.new('scrap')
    scrap.write_content(tempfile)
    tempfile.close
    old_content = scrap.content
    system("#{editor} #{tempfile.path}")
    tempfile.open
   
    scrap.read_content(tempfile)
    if scrap.content != old_content
      puts "Scrap modified, saving."
      scrap.metadata.modified_at = DateTime::now
      storage << scrap
    elsif
      puts "Not modified."
    end
    
    tempfile.close
    storage.close
  end

  def ShowCommand::word
    'show'
  end

  def ShowCommand::hint
    'show KEYWORD : show and edit the note matching the keyword (via id, nick and title)'
  end
end
