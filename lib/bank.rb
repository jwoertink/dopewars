class Bank

  attr_accessor :loan_amount, :savings_account

  def initialize
    @loan_amount = 0
    @savings_account = 0
    @interest = 0.25
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
