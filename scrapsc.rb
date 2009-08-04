require 'rubygems'
require 'newcommand'
require 'listcommand'

# scrapsc new "Some title"
# scrapsc list [--all]
# scrapsc edit [nick | id | title]
# scrapsc show [nick | id | title]
# scrapsc nick [nick | id | title] nick

commands = [NewCommand, ListCommand]

commands.each { |command_class|
  if command_class::word == ARGV[0]
    puts "Calling #{command_class}"
    c = command_class::new(ARGV)
    c.walk!
    c.do!
  end
}

