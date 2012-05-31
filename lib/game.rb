class Game
  include Utilities
  
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
    when "1"
      buyers_menu
    when "2"
      sellers_menu
    when "3"
      airport_menu
    when "4"
      bank_menu
    when "5"
      check_stats_menu
    else
      echo(game_text(:bad_selection), :red)
      echo(game_text(:main_menu), :blue, 0)
      menu_option = ask("Select your option:")
      select_menu(menu_option)
    end
  end
  
  def buyers_menu
    echo(game_text(:buyers_menu), :blue, 0)
    available_options = []
    drugs = []
    Drug::TYPES.each_with_index do |drug, select_number|
      dime_bag = Drug.new({name: drug, price: Drug.street_price, quantity: 0})
      drugs << dime_bag
      max_amount = @player.wallet / dime_bag.price
      echo("#{select_number + 1}. #{dime_bag.name} @ $#{dime_bag.price} {#{max_amount}}", :cyan, 0)
      available_options << (select_number + 1)
    end
    loop do
      menu_option = ask("Select your option:")
      if (menu_option =~ /\d+/).to_i >= 0 and available_options.include?(menu_option.to_i)
        drug = drugs[menu_option.to_i - 1]
        amount = ask("How Many?")
        decrease = (drug.price * amount.to_i)
        if @player.can_buy_drug?(drug.price, amount.to_i)
          @player.add_to_drugs({drug.name => amount.to_i})
          @player.wallet -= decrease
          echo("You have $#{@player.wallet} left.", :cyan)
          break
        else
          echo("You can't buy that many.", :red)
        end
      end
    end
  end
  
  def sellers_menu
    echo(game_text(:sellers_menu), :blue, 0)
    i = 0
    drugs = []
    @player.drugs.each_pair do |drug, amount|
      dime_bag = Drug.new({name: drug, price: Drug.street_price, quantity: amount})
      echo("#{i + 1}. #{dime_bag.name} x #{dime_bag.quantity} @ $#{dime_bag.price}ea", :cyan, 0)
      drugs << dime_bag
      i +=1
    end
    loop do
      menu_option = ask("Select your option:")
      if (menu_option =~ /\d+/).to_i >= 0 and (0..i).to_a.include?(menu_option.to_i)
        drug = drugs[menu_option.to_i - 1]
        amount =  ask("How many?")
        if amount.to_i <= @player.drugs[drug.name]
          @player.remove_from_drugs({drug.name => amount.to_i})
          increase = drugs[menu_option.to_i - 1].price * amount.to_i
          @player.wallet += increase
          echo("You made $#{increase}", :cyan)
          break
        else
          echo("You can't sell more then #{drug.quantity} of #{drug.name}.", :red, 0)
        end
      else
        echo("You must select an option", :red, 0)
      end
    end
  end
  
  def airport_menu
    city_options = ""
    available_options = []
    Game::LOCATIONS.each_with_index do |city, select_number|
      next if @current_location.eql?(city)
      available_options << (select_number + 1)
      city_options += "#{select_number + 1}. #{city}\n"
    end
    echo(game_text(:airport_menu, {current_city: @current_location ,city_options: city_options}), :blue, 0)
    loop do
      menu_option = ask("Select your option:")
      if (menu_option =~ /\d+/).to_i >= 0 and available_options.include?(menu_option.to_i)
        @current_location = Game::LOCATIONS[menu_option.to_i - 1]
        echo("You fly to #{@current_location}", :cyan)
        break
      else
        echo("You must select an option", :red, 0)
      end
    end
    
    @player.end_turn!
  end
  
  def bank_menu
    echo(game_text(:bank_menu), :blue, 0)
    menu_option = ask("Select your option:")
    loop do
      case menu_option
      when "1" # Take out a loan
        amount = ask("How much?")
        @player.wallet += amount.to_i
        @player.bank_account.increase_loan(amount.to_i)
        echo("You now have $#{@player.wallet}", :cyan)
        break
      when "2" # Pay onto a loan
        puts "Your current loan amount is #{@player.bank_account.loan_amount}"
        amount = ask("How much would you like to pay?")
        if amount.to_i > @player.wallet
          echo("Sorry, you don't have that much money.", :red)
        else
          @player.wallet -= amount.to_i
          @player.bank_account.decrease_loan(amount.to_i)
          break
        end
      when "3" # Put money into savings
        amount = ask("How much?")
        if amount.to_i > @player.wallet
          echo("Sorry, you don't have that much money.", :red)
        else
          @player.wallet -= amount.to_i
          @player.bank_account.increase_savings(amount.to_i)
          break
        end
      when "4" # Take money from savings
        amount = ask("How much?")
        if amount.to_i > @player.wallet
          echo("Sorry, you don't have that much money.", :red)
        else
          @player.wallet += amount.to_i
          @player.bank_account.decrease_savings(amount.to_i)
          break
        end
      when "5" #leave
        echo("Goodbye.", :blue)
        break
      else
        menu_option = ask("Please select an available option:")
      end
    end
  end
  
  def check_stats_menu
    echo(game_text(:check_stats_menu), :blue, 0)
    str = "Current Location: #{@current_location}\n"
    str << "Days remaining: #{days_remaining}\n"
    echo(@player.stats << str, :yellow)
  end
  
  #Main game loop
  def start!
    echo(game_text(:welcome, {:name => @player.name, :amount => @player.wallet, :drug => @player.drugs.keys.first}), :green)
    echo(game_text(:dealer_introduction), :green)
    echo("You have #{days_remaining} Days Remaining", :yellow, 1)
    while days_remaining > 0
      @player.start_turn!
      loop do
        echo(game_text(:main_menu), :blue, 0)
        menu_option = ask("Select your option:")
        select_menu(menu_option)
        break if @player.end_of_turn?
      end
      break if game_over? or @player.captured?
      @current_day += 1
      echo("You have #{days_remaining} Days Remaining", :yellow)  
    end

    finish!
  end
  
  def finish!
    echo("Game Over", :red, 0)
    echo("Final Stats:", :blue)
    echo(@player.stats, :yellow)
    exit
  end
  
end