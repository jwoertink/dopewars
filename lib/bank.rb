class Bank

  def initialize
    @loan_amount = 0
    @savings_account = 0
    @interest = rand(0.03...0.11).round(3) # Random between 3% and 11%
  end

  def loan_amount
    @loan_amount.round(2)
  end

  def savings_account
    @savings_account.round(2)
  end

  def increase_loan(amount)
    @loan_amount += amount
  end

  def decrease_loan(amount)
    @loan_amount -= amount
  end

  def increase_savings(amount)
    @savings_account += amount
  end

  def decrease_savings(amount)
    @savings_account -= amount
  end

  def add_daily_interest
    dividend = @savings_account * @interest
    @savings_account += dividend
    loan = @loan_amount * @interest
    @loan_amount += loan
  end

end
