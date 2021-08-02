class OysterCard
  attr_accessor :balance

  INITIAL_BALANCE = 500

  def initialize balance = INITIAL_BALANCE
    @balance = balance
  end
end