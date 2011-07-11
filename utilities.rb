module Utilities
  
  GAME_TITLE = <<-MSG
******************
* Dopewars v1.1
* 
******************
MSG
  
  def echo(message, colour, wait_time = 2)
    const = ::HighLine.const_get(colour.to_s.upcase)
    puts const
    say("<%= color('#{message}', '#{const}') %>")
    sleep wait_time
  end
  
end