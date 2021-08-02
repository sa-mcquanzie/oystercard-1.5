require 'oystercard'

describe OysterCard do
  context 'when it is first created' do
    it 'has money on it' do
      expect(subject.balance).to eq(500)
    end 
  end

  context 'after it is created' do
    it 'allows the user to add money to the balance' do
      subject.top_up 500
      expect(subject.balance).to eq(1000)
    end

    it 'prevents the user from exceeding the maximum balance' do
      expect { subject.top_up(9501) }
      .to raise_error 'Top-up exceeds maximum balance'
    end

    it 'allows a fare to be deducted from the balance' do
      journey = double('Journey')

      allow(journey).to receive(:fare) { 250 }

      subject.deduct journey.fare

      expect(subject.balance).to eq(250)
    end

    it 'allows a user to touch in at a station' do
      station = double('Station')

      allow(station).to receive(:name) { 'Peckham Rye'}

      expect(subject.touch_in station). to eq("Touched in at Peckham Rye")
    end

    it 'allows a user to touch out at a station' do
      station = double('Station')

      allow(station).to receive(:name) { 'London Bridge'}

      expect(subject.touch_out station). to eq("Touched out at London Bridge")
    end

    it 'prevents a user from travelling with less than the minimum fare' do
      subject.deduct 251

      station = double('Station')

      allow(station).to receive(:name) { 'Peckham Rye'}

      expect { subject.touch_in station }.to raise_error 'Insufficient funds'
    end

    it 'marks the user as in transit when they touch in' do
      station = double('Station')

      allow(station).to receive(:name) { 'Peckham Rye'}

      subject.touch_in station

      expect(subject.in_transit?).to eq(true)
    end
  end
end