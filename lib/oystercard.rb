class OysterCard
  attr_accessor :balance

  INITIAL_BALANCE = 500
  MAX_BALANCE = 10000

  def initialize balance = INITIAL_BALANCE
    @balance = balance
    @max_balance = MAX_BALANCE
  end

  def top_up amount
    new_balance = @balance + amount
    raise 'Top-up exceeds maximum balance' if new_balance > @max_balance
    @balance += amount
  end
end