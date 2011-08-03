require 'yaml'

module Utilities
  
  GAME_TITLE = <<-MSG
******************
* Dopewars v1.1
* 
******************
MSG
  
  def echo(message, colour = :white, wait_time = 2)
    const = ::HighLine.const_get(colour.to_s.upcase)
    say(%{<%= color("#{message}", "#{const}") %>})
    sleep wait_time
  end
  
  def game_defaults
    {playable: true, days: 30, current_day: 0, current_location: Game::LOCATIONS.sort_by { rand }.first}
  end
  
  def game_text(key, vars = {})
    @yml ||= YAML::load(File.open(File.expand_path(File.join(File.dirname(__FILE__), "text.yml"))))["game"]
    unless vars.empty?
      vars.keys.each do |k|
        @yml[key.to_s].gsub!("%{#{k}}", "#{vars[k]}")
      end
    end
    @yml[key.to_s]
  end
  
end