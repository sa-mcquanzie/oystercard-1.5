class OysterCard
  attr_accessor :balance, :history

  INITIAL_BALANCE = 500
  MIN_BALANCE = 250
  MAX_BALANCE = 10000
  MAX_FARE = 700

  def initialize balance = INITIAL_BALANCE
    @balance = balance
    @history = []
    @in_transit = false
    @max_balance = MAX_BALANCE
    @min_balance = MIN_BALANCE
    @max_fare = MAX_FARE
  end

  def top_up amount
    new_balance = @balance + amount

    raise 'Top-up exceeds maximum balance' if new_balance > @max_balance

    @balance += amount
  end

  def deduct fare
    @balance -= fare
  end

  def touch_in station
    raise 'Insufficient funds' if @balance < @min_balance
  
    unless @history.empty?
      if @history.last.has_key?(:start) && !@history.last.has_key?(:finish)
        @history[-1] = { :start => nil, :finish => nil }
        deduct @max_fare
        return 'Previous journey incomplete' 
      end
    end

    @in_transit = true

    @history << { :start => station }

    if @history.size == 1 || @history.last.has_key?(:finish)
      return "Touched in at #{station.name}"
    end
  end

  def touch_out station
    @in_transit = false

    unless @history.empty? || @history.last.has_key?(:finish)
      @history.last[:finish] = station
      return "Touched out at #{station.name}"
    end

    @history = [{}] if @history.empty?

    @history[-1] = { :start => nil, :finish => nil }
    return 'Incomplete journey'
  end

  def in_transit?
    @in_transit
  end
end