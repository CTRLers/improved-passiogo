require 'rails_helper'

RSpec.describe Bus, type: :model do
  let(:bus) { Bus.new(bus_number: '12345', capacity: 50, status: 'active', bus_color: 'red') }

  context 'validations' do
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

    it 'is not valid without a bus color' do
      bus.bus_color = nil
      expect(bus).not_to be_valid
    end

    it 'is not valid with a duplicate bus number' do
      bus.save
      duplicate_bus = bus.dup
      expect(duplicate_bus).not_to be_valid
    end
  end

  context 'default values' do
    it 'has a default status of active' do
      new_bus = Bus.new(bus_number: '54321', capacity: 30, bus_color: 'blue')
      expect(new_bus.status).to eq('active')
    end
  end
end
