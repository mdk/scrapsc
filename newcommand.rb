require 'command'

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
    #editor = ENV['EDITOR'] || 'vi'
    #tempfile = Tempfile.new('scrap')
    #system("#{editor} #{tempfile.path}")
    #scrap = Scrap::new
    #scrap.read_content(tempfile.path)
    #scrap.metadata.title = walker.title
    #storage << scrap
  end
end

