class Game
  
  LOCATIONS = ["Las Vegas", "New York", "Miami", "Amsterdam", "Frankfurt", "El-Jazier"]
  
  def initialize(defaults = {})
    defaults.each_pair { |key,value| instance_variable_set("@#{key}", value) }
  end
  
  def playable?
    @playable
  end
  
  def game_over?
    @days <= 0 or !playable?
  end
  
  def days_remaining
    @days - @current_day
  end
  
  #Maybe this should be moved?
  def select_menu(menu_option)
    case menu_option
    when 1
      @player.buy_drugs
    when 2
      @player.sell_drugs
    when 3
      @player.fly_to_city
    when 4
      @player.go_to_bank
    when 5
      @player.check_stats
    else
      echo(game_text(:bad_selection), :red)
      echo(game_text(:main_menu), :blue, 0)
      menu_option = ask("Select your option:")
      select_menu(menu_option)
    end
  end
  
  #Main game loop
  def start!
    echo(game_text(:welcome, {:name => @player.name, :amount => @player.wallet, :drug => @player.drugs.keys.first}), :green)
    echo(game_text(:dealer_introduction), :green)
    echo("You have #{days_remaining} Days Remaining", :yellow, 1)
    while days_remaining > 0
      echo(game_text(:main_menu), :blue, 0)
      menu_option = ask("Select your option:")
      select_menu(menu_option)
      @player.bank_account.add_daily_interest
      agent = Agent.new if Agent.available?
      echo("You have #{days_remaining} Days Remaining", :yellow)
      @current_day += 1
      break if game_over?
    end

    finish!
  end
  
  def finish!
    echo("Game Over", :red, 0)
    exit
  end
  
end