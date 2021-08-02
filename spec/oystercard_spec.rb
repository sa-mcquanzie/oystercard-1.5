require 'oystercard'

describe OysterCard do
  context 'when it is first created' do
    it 'has money on it' do
      expect(subject.balance).to eq(500)
    end 
  end

  context 'after it is created' do
    it 'allows the user to add money to the balance' do
      subject.top_up(500)
      expect(subject.balance).to eq(1000)
    end

    it 'prevents the user from exceeding the maximum balance' do
      expect { subject.top_up(9501) }
      .to raise_error 'Top-up exceeds maximum balance'
    end
  end
end