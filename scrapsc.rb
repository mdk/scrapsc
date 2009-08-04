require 'rubygems'
require 'ostruct'
require 'optparse'
require 'scrap'
require 'storage'
require 'optwalkers'

# scrapsc new "Some title"
# scrapsc list [--all]
# scrapsc edit [nick | id | title]
# scrapsc show [nick | id | title]
# scrapsc nick [nick | id | title] nick

storage = Storage::new
if ARGV[0] == 'new'
  walker = NewWalker::new(ARGV)
  walker.walk!

  editor = ENV['EDITOR'] || 'vi'
  system("#{editor} temp.tmp")

  scrap = Scrap::new
  scrap.read_content('temp.tmp')
  scrap.metadata['metadata:Title'] = walker.title
  
  storage << scrap
elsif ARGV[0] == 'list'
  storage.each { |scrap|
    puts "* #{scrap.local_id} - #{scrap.metadata['metadata:Title']}"
  }
end
