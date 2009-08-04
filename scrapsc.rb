require 'rubygems'
require 'newcommand'
require 'listcommand'
require 'findcommand'
require 'infocommand'

# scrapsc new "Some title"
# scrapsc list [--all]
# scrapsc edit [nick | id | title]
# scrapsc show [nick | id | title]
# scrapsc nick [nick | id | title] nick

commands = [NewCommand, ListCommand, FindCommand, InfoCommand]

if ARGV.length == 0
  puts "Commands:"
  commands.each { |command_class|
    puts "  scrapsc #{command_class::hint}"
  }
exit
end

commands.each { |command_class|
  if command_class::word == ARGV[0]
    c = command_class::new(ARGV)
    c.walk!
    c.do!
  end
}

