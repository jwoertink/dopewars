require 'yaml'

module Utilities
  GAME_ROOT = File.join(File.dirname(__FILE__), '..')
  VERSION = File.read(File.join(GAME_ROOT, 'VERSION'))

  GAME_TITLE = <<-MSG
**********************************
  Dopewars v#{VERSION}
**********************************
MSG

  TEXT = {
    reset:     "\e[0m",
    black:     "\e[30m",
    red:       "\e[31m",
    green:     "\e[32m",
    yellow:    "\e[33m",
    blue:      "\e[34m",
    purple:    "\e[35m",
    cyan:      "\e[36m",
    gray:      "\e[37m",
    underline: "\e[4m",
    blink:     "\e[5m",
    invert:    "\e[7m",
    blank:     "\e[8m"
  }

  def ascii(message)
    @ascii ||= Artii::Base.new
    @ascii.asciify(message)
  end

  def color(text, kolor = :white)
    "#{TEXT[kolor]}#{text}#{TEXT[:reset]}"
  end

  def echo(message, colour = :white, wait_time = 1)
    puts color(message, colour)
    sleep wait_time
  end

  def game_defaults
    {playable: true, days: 30, current_day: 0, current_location: City.new}
  end

  def game_text(key, vars = {})
    @yml ||= YAML.load(File.open(File.join(GAME_ROOT, "config", "text.yml")))["game"]
    unless vars.empty?
      vars.keys.each do |k|
        @yml[key.to_s].gsub!("%{#{k}}", "#{vars[k]}")
      end
    end
    @yml[key.to_s]
  end

  def money_format(amount)
    dollars, cents = amount.round(2).to_s.split('.')
    str = "$"
    str << dollars.reverse.scan(/.{1,3}/).reverse.map(&:reverse).join(',')
    str << "."
    str << cents
    str
  end

end
