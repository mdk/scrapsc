require 'rubygems'
require 'ostruct'
require 'optparse'
require 'scrap'
require 'storage'
require 'newcommand'
require 'listcommand'
require 'tempfile'

# scrapsc new "Some title"
# scrapsc list [--all]
# scrapsc edit [nick | id | title]
# scrapsc show [nick | id | title]
# scrapsc nick [nick | id | title] nick

commands = [NewCommand, ListCommand]
storage = Storage::new

commands.each { |command_class|
  if command_class::word == ARGV[0]
    puts "Calling #{command_class}"
    c = command_class::new(ARGV)
    c.walk!
    c.do!
  end
}
exit

if ARGV[0] == 'new'
  walker = NewWalker::new(ARGV)
  walker.walk!

  editor = ENV['EDITOR'] || 'vi'
  tempfile = Tempfile.new('scrap')
  system("#{editor} #{tempfile.path}")

  scrap = Scrap::new
  scrap.read_content(tempfile.path)
  scrap.metadata.title = walker.title
  
  storage << scrap
elsif ARGV[0] == 'list'
  storage.each { |scrap|
    puts "* #{scrap.local_id} - #{scrap.metadata.title}"
  }
end
