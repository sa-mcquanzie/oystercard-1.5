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
      peckham_rye = double('Station')
      london_bridge = double('Station')

      allow(peckham_rye).to receive(:name) { 'Peckham Rye'}
      allow(london_bridge).to receive(:name) { 'London Bridge'}

      subject.touch_in peckham_rye

      expect(subject.touch_out london_bridge). to eq("Touched out at London Bridge")
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

    it 'marks the user as no longer in transit when they touch out' do
      peckham_rye = double('Station')
      london_bridge = double('Station')

      allow(peckham_rye).to receive(:name) { 'Peckham Rye'}
      allow(london_bridge).to receive(:name) { 'London Bridge'}

      subject.touch_in peckham_rye
      subject.touch_out london_bridge

      expect(subject.in_transit?).to eq(false)
    end

    it 'has a place to store journey history' do
      expect(subject.history).to eq([])
    end

    it 'adds new journeys to the history' do
      station = double('Station')

      allow(station).to receive(:name) { 'Peckham Rye'}

      subject.touch_in station

      expect(subject.history.last[:start]).to eq(station)
    end

    it 'completes journeys when the user touches out' do
      peckham_rye = double('Station')
      london_bridge = double('Station')

      allow(peckham_rye).to receive(:name) { 'Peckham Rye'}
      allow(london_bridge).to receive(:name) { 'London Bridge'}

      subject.touch_in peckham_rye
      subject.touch_out london_bridge

      expect(subject.history.last[:finish]).to eq(london_bridge)
    end

    it 'creates an incomplete journey if the user touches out without touching in' do
      station = double(station)

      allow(station).to receive(:name) { 'Peckham Rye'}
      
      expect(subject.touch_out station).to eq('Incomplete journey')
    end
  end
end