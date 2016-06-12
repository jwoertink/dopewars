require 'win32console' if RUBY_PLATFORM =~ /mingw/
require "artii"
require 'highline/import'
require 'yaml'
require 'utilities'
require 'drug'
require 'city'
require 'weapon'
require 'fighter'
require 'player'
require 'container'
require 'bank'
require 'agent'
require 'battle'
require 'game'

module Application
  extend Utilities

  # This just kicks off the application.
  def self.run!
    echo(ascii("Dopewars"), :purple, 0)
    echo("v#{Utilities::VERSION}", :purple, 0)
    key = ask("[S]tart a new game or [Q]uit?")

    if key.downcase.eql?('s')
      player_name = ask(color(game_text(:greeting), :green))
      player_defaults = {name: player_name, wallet: 500, drugs: {weed: 5}}
      @game = Game.new(game_defaults.merge(player: Player.new(player_defaults)))
      @game.start!
    else
      echo("Goodbye!", :red, 0)
      exit
    end
  end

end
