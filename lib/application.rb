require 'win32console' if RUBY_PLATFORM =~ /mingw/
require 'highline/import'
require 'utilities'
require 'game'
require 'player'
require 'drug'
require 'bank'
require 'agent'


module Application
  extend Utilities
  
  # This just kicks off the application.
  def self.run!
    echo(Utilities::GAME_TITLE, :green, 0)
    key = ask("[S]tart a new game or [Q]uit?") { |q| q.echo = true }

    if key.downcase.eql?('s')
      player_name = ask(game_text(:greeting))
      player_defaults = {name: player_name, wallet: 500, drugs: {weed: 5}}
      @game = Game.new(game_defaults.merge(player: Player.new(player_defaults)))
      @game.start!
    else
      echo("Goodbye!", :red, 0)
      exit
    end
  end

end