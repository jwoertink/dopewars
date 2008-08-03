require "game"

puts "Dopewars v1.0"
puts "press 'S' to continue or any (other) key to quit."
@game = Game.new
answer = gets.chomp
if answer.downcase.eql?('s')
  puts "Welcome new drug dealer, what is your name?"
  name = gets.chomp
  @player = Player.new(name)
  puts "Nice to meet you #{@player.name}. Here is $500.00 and some weed to get you started."
  sleep 2
  @player.add_to_drugs({"weed" => 5})
  @player.funds += 500
  puts "Now that you have that, there is one more thing you will need."
  sleep 2
  puts "Here is a special plane ticket, and boarding pass."
  sleep 2
  puts "This will allow you to travel to one of 6 special cities."
  sleep 2
  puts "You may also need this bag to carry stuff in. You have 30 days."
  sleep 3
  while @player.days_remaining > 0
    puts "What would you like to do?"
    puts "1. Buy drugs\n2. Sell drugs\n3. Fly to a new city\n4. Go to the bank.\n5. Check stats."
    puts "Select your option:"
    option = gets.chomp
    case option
    when 1.to_s
      @player.buy_drugs
    when 2.to_s
      @player.sell_drugs
    when 3.to_s
      @player.fly_to_city
    when 4.to_s
      @player.go_to_bank
    when 5.to_s
      @player.check_stats
    else
      puts "You must select a number 1 through 4"
    end
    
    @player.days_remaining -= 1
    @player.bank_account.add_daily_interest
    if Game.agent?
      Game.random_agent
    end
  end
  
  puts "You've done it. You're now gangsta!"
end
