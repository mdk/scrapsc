require 'rubygems'
require 'ostruct'
require 'optparse'
require 'scrap'
require 'storage'

# scrapsc new "Some title"
# scrapsc list [-all]
# scrapsc edit [nick | id | title]
# scrapsc show [nick | id | title]
# scrapsc nick [nick | id | title] nick

storage = Storage::new
if ARGV[0] == 'new'
  editor = ENV['EDITOR'] || 'vi'
  system("#{editor} temp.tmp")
  scrap = Scrap::new
  scrap.read_content('temp.tmp')
  storage << scrap
elsif ARGV[0] == 'list'
  storage.each { |scrap|
    puts "* #{scrap.local_id}"
  }
end
