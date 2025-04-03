require 'rails_helper'

RSpec.describe Bus, type: :model do
  let(:bus) { FactoryBot.build(:bus) }

  context 'Validations' do
    it 'is valid with valid attributes' do
      expect(bus).to be_valid
    end

    it 'is not valid without a bus number' do
      bus.bus_number = nil
      expect(bus).not_to be_valid
    end

    it 'is not valid without a capacity' do
      bus.capacity = nil
      expect(bus).not_to be_valid
    end

    it 'is not valid if capacity is less than 1' do
      bus.capacity = 0
      expect(bus).not_to be_valid
    end
  end

  context 'Associations' do
    it { should belong_to(:route) }
    it { should have_many(:bookings) }
  end

  context 'Methods' do
    it 'returns the correct bus information' do
      bus.bus_number = '123'
      bus.capacity = 50
      expect(bus.info).to eq('Bus Number: 123, Capacity: 50')
    end
  end
end
