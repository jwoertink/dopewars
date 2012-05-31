=begin
  This file is an experimental test to create a global session for the game
  the idea would be to allow input from any point in the game and not just during menu choices
  the benefit would mean you could access any menu at any time.
=end

require 'rubygems'
require 'bundler'
Bundler.require(:experimental)

# get the original settings and save a backup
term = Termios::getattr($stdin)
original_term = term.dup

# non-canonical mode: character input
term.c_lflag &= ~Termios::ICANON

# disable echo
term.c_lflag &= ~Termios::ECHO

Termios.setattr($stdin, Termios::TCSANOW, term)

threads = []

threads << Thread.new("root") do
  while c = STDIN.getc
    puts "Read: #{c.inspect}"
  end
end

threads << Thread.new("side") do
  puts "doing stuff here?"
end
threads.map(&:join)

Termios.setattr($stdin, Termios::TCSANOW, original_term)