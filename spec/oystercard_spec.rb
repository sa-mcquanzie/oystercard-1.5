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
  end
end