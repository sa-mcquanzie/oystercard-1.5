class OysterCard
  attr_accessor :balance, :history

  INITIAL_BALANCE = 500
  MAX_BALANCE = 10000
  MIN_FARE = 250
  PENALTY_FARE = 700

  def initialize balance = INITIAL_BALANCE
    @balance = balance
    @history = []
    @in_transit = false
    @max_balance = MAX_BALANCE
    @min_fare = MIN_FARE
    @penalty_fare = PENALTY_FARE
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
    raise 'Insufficient funds' if @balance < @min_fare
  
    unless @history.empty?
      if @history.last.has_key?(:start) && !@history.last.has_key?(:finish)
        @history.last[:finish] = nil
        
        deduct @penalty_fare

        return 'Previous journey incomplete' 
      end
    end

    @in_transit = true

    @history << { :start => station }

    "Touched in at #{station.name}"
  end

  def touch_out station
    @in_transit = false

    unless @history.empty? || @history.last.has_key?(:finish)
      @history.last[:finish] = station
      return "Touched out at #{station.name}"
    end

    @history = [{}] if @history.empty?
    @history[-1] = { :start => nil, :finish => station }

    return 'Incomplete journey'
  end

  def in_transit?
    @in_transit
  end
end
