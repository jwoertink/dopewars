require 'rubygems'
require 'bundler'
Bundler.require
require 'highline/import'
Dir["#{File.expand_path(File.join(File.dirname(__FILE__)))}/*.rb"].each { |file| require file unless file.eql?(File.expand_path(__FILE__)) }
include Utilities


echo(Utilities::GAME_TITLE, :green, 0)
key = ask("[S]tart a new game or [Q]uit?") { |q| q.echo = true }

if key.downcase.eql?('s')
  player_name = ask("What is your name?")
  player_defaults = {name: player_name, wallet: 500, drugs: {weed: 5}}
  game = Game.new(game_defaults.merge(player: Player.new(player_defaults)))
  game.start!
else
  echo("Goodbye!", :red, 0)
  exit
end
