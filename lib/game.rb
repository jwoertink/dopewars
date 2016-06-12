class Game
  include Utilities

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

  def awareness_level_warning
    level = case @current_location.transactions
    when 3
      echo(game_text(:awareness_notice, {city: @current_location.name}), :yellow, 0)
      0 # no chance of getting caught
    when 4
      echo(game_text(:high_awareness_notice), :yellow, 0)
      (rand(100) + 30) # 40% chance of being safe
    when 5
      echo(game_text(:high_awareness_notice), :yellow, 0)
      (rand(100) + 40) # 30% chance of being safe
    when 6
      echo(game_text(:high_awareness_notice), :yellow, 0)
      (rand(100) + 50) # 20% chance of being safe
    when 7
      echo(game_text(:high_awareness_notice), :yellow, 0)
      (rand(100) + 60) # 10% chance of being safe
    else
      0
    end

    return level
  end

  #Maybe this should be moved?
  def select_menu(menu_option)
    level = awareness_level_warning

    if level > 70
      battle_agent_menu
    else
      case menu_option
      when '1'
        #battle_agent_menu
        buyers_menu
      when '2'
        sellers_menu
      when '3'
        airport_menu
      when '4'
        bank_menu
      when '5'
        check_stats_menu
      when '6'
        gym_menu
      when '7'
        store_menu
      when '?'
        help_menu
      else
        echo(game_text(:bad_selection), :red, 0)
        echo(game_text(:main_menu), :blue, 0)
        menu_option = ask("Select your option: ") { |q| q.in = ('1'..'6').to_a }
        select_menu(menu_option)
      end
    end
  end

  def buyers_menu
    if @player.can_afford_drugs?(@current_location.drugs)
      echo(game_text(:buyers_menu), :blue, 0)
      available_options = []
      drugs = []
      @current_location.drugs.each_with_index do |drug, select_number|
        drugs << drug
        max_amount = @player.wallet / drug.price
        echo("#{select_number + 1}. #{drug.name} @ $#{drug.price} {#{max_amount}}", :cyan, 0)
        available_options << (select_number + 1)
      end
      loop do
        menu_option = ask("Select your option: ", Integer) { |q| q.in = available_options.map(&:to_i) }
        drug = drugs[menu_option - 1]
        amount = ask("How Many? ", Integer) { |q| q.above = 0 }
        decrease = (drug.price * amount.to_i)
        if @player.can_buy_drug?(drug.price, amount.to_i)
          @player.add_to_drugs({drug.name => amount.to_i})
          @player.wallet -= decrease
          echo("You have $#{@player.wallet} left.", :cyan)
          @current_location.transactions += 1
          break
        else
          echo("You can't buy that many.", :red)
        end
      end
    else
      echo("You're too broke to purchase. Go to the bank.", :red)
    end
  end

  def sellers_menu
    if @player.has_drugs?
      echo(game_text(:sellers_menu), :blue, 0)
      i = 0
      drugs = []
      @player.drugs.each_pair do |drug, amount|
        dime_bag = Drug.new({name: drug, price: @current_location.market_price_for_drug, quantity: amount})
        echo("#{i + 1}. #{dime_bag.name} x #{dime_bag.quantity} @ $#{dime_bag.price}ea", :cyan, 0)
        drugs << dime_bag
        i += 1
      end
      loop do
        menu_option = ask("Select your option: ", Integer) { |q| q.in = 0..i }
        drug = drugs[menu_option - 1]
        amount =  ask("How many? ", Integer)
        if amount.to_i <= @player.drugs[drug.name]
          @player.remove_from_drugs({drug.name => amount.to_i})
          increase = drugs[menu_option.to_i - 1].price * amount.to_i
          @player.wallet += increase
          echo("You made $#{increase}", :cyan)
          @current_location.transactions += 1
          break
        else
          echo("You can't sell more then #{drug.quantity} of #{drug.name}.", :red, 0)
        end
      end
    else
      echo("You must purchase drugs first", :red, 0)
    end
  end

  def airport_menu
    echo(ascii(game_text(:airport_title)), :purple, 0)
    city_options = ""
    available_options = []
    City::LOCATIONS.each_with_index do |city, select_number|
      next if @current_location.name.eql?(city)
      available_options << (select_number + 1)
      city_options += "#{select_number + 1}. #{city}\n"
    end
    available_options << (City::LOCATIONS.length + 1)
    city_options += "#{City::LOCATIONS.length + 1}. Leave\n"
    echo(game_text(:airport_menu, {current_city: @current_location.name ,city_options: city_options}), :blue, 0)
    loop do
      menu_option = ask("Select your option: ", Integer) { |q| q.in = available_options.map(&:to_i) }
      case menu_option
      when City::LOCATIONS.length + 1
        echo("Goodbye.", :green)
        break
      else
        @current_location = City.new(name: City::LOCATIONS[menu_option.to_i - 1])
        echo("You fly to #{@current_location.name}", :cyan)
        if @player.encounter_agent?
          battle_agent_menu
        else
          @player.end_turn!
        end
        break
      end
    end
  end

  def bank_menu
    echo(ascii(game_text(:bank_title)), :purple, 0)
    echo(game_text(:bank_menu), :blue, 0)
    menu_option = ask("Select your option:")
    loop do
      case menu_option
      when "1" # Take out a loan
        amount = ask("How much do you need?")
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
        puts "You have $#{@player.wallet} on you."
        amount = ask("How much do you want to deposit?")
        if amount.to_i > @player.wallet
          echo("Sorry, you don't have that much money.", :red)
        else
          @player.wallet -= amount.to_i
          @player.bank_account.increase_savings(amount.to_i)
          break
        end
      when "4" # Take money from savings
        puts "You have $#{@player.bank_account.savings_account} in savings."
        amount = ask("How much do you want to take out?")
        if amount.to_i > @player.bank_account.savings_account
          echo("Sorry, you don't have that much money.", :red)
        else
          @player.wallet += amount.to_i
          @player.bank_account.decrease_savings(amount.to_i)
          break
        end
      when "5" #leave
        echo("Goodbye.", :green)
        break
      else
        menu_option = ask("Please select an available option:")
      end
    end
  end

  def check_stats_menu
    echo(ascii(game_text(:stats_title)), :purple, 0)
    str = " Current Location: #{@current_location.name}\n"
    str << " Days remaining: #{days_remaining}\n"
    echo(@player.stats << str, :cyan)
  end

  def gym_menu
    if @player.visited_gym?(@current_location)
      echo("You've already worked out today, come back tomorrow.", :red)
    else
      echo(ascii(game_text(:gym_title)), :purple, 0)
      echo(game_text(:gym_menu), :blue)
      menu_option = ask("Select your option:")
      loop do
        case menu_option
        when '1'
          current_level = @player.level
          @player.workout!
          if @player.level > current_level
            echo(game_text(:player_gained_level, {:level => @player.level, :new_stats => @player.stats(false)}), :green, 0)
          else
            echo("You had a good workout, but still need improvement", :cyan)
          end
          @current_location.gym_closed = true
          break
        when '2' #leave
          echo("Goodbye.", :green)
          break
        else
          help_menu
        end
      end
    end
  end

  def store_menu
    echo(ascii(game_text(:store_title)), :purple, 0)
    echo(game_text(:store_main_menu), :blue)
    menu_option = ask("Select your option:")
    loop do
      case menu_option
      when '1'
        i = 0
        items = []
        available_options = []
        Weapon.all.each do |weapon|
          items << weapon["type"]
          echo("#{i + 1}. #{weapon["type"]} @ $#{weapon["cost"]}", :cyan, 0)
          i += 1
          available_options << i
        end
        Container.all.each do |container|
          items << container["size"]
          echo("#{i + 1}. #{container["name"]} container @ $#{container["cost"]}", :cyan, 0)
          i += 1
          available_options << i
        end
        loop do
          menu_option = ask("Select your option: ", Integer) { |q| q.in = available_options.map(&:to_i) }
          item = items[menu_option - 1]
          if Weapon.find(item)
            @player.weapon = Weapon.new(type: item)
            @player.wallet -= @player.weapon.cost
          else
            @player.container = Container.new(size: item)
            @player.wallet -= @player.container.cost
          end
          break
        end
        break
      when '2' #leave
        echo("Goodbye.", :green)
        break
      else
        help_menu
      end
    end
  end

  def battle_agent_menu
    agent = Agent.new
    echo("#{@player.name}, there is an agent chasing you!", :yellow)
    current_battle = Battle.new(@player, [agent])
    current_battle.start
  end

  def help_menu
    echo(ascii(game_text(:help_menu_title)), :purple, 0)
    echo(game_text(:help_menu), :blue)
  end

  #Main game loop
  def start!
    echo(game_text(:welcome, {name: @player.name, amount: @player.wallet, drug: @player.drugs.keys.first}), :green)
    echo(game_text(:dealer_introduction), :green)
    echo("You have #{days_remaining} Days Remaining", :yellow)
    while days_remaining > 0
      @player.start_turn!
      loop do
        echo(game_text(:main_menu), :blue, 0)
        menu_option = ask("Select your option:")
        select_menu(menu_option)
        break if @player.end_of_turn? or @player.captured?
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
    if days_remaining.zero?
      echo(@player.final_stats, :green)
    else
      echo(@player.stats, :yellow)
    end
    exit
  end

end
