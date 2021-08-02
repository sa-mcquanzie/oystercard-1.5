require 'oystercard'

describe OysterCard do
  context 'when it is first created' do
    it 'has money on it' do
      expect(subject.balance).to eq(500)
    end
  end
end