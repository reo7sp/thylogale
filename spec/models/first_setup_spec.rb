require 'rails_helper'

RSpec.describe FirstSetup, type: :model do
  it 'allows one instance' do
    FirstSetup.create!
    expect { FirstSetup.create! }.to raise_error ActiveRecord::RecordInvalid
  end

  it 'sets done to false by default' do
    FirstSetup.create!
    expect(FirstSetup.instance.done).to be false
  end

  describe '#instance' do
    it 'creates new instance if none exists' do
      expect { FirstSetup.instance }.to change { FirstSetup.count }.from(0).to(1)
    end

    it 'returns first object' do
      FirstSetup.create!
      expect(FirstSetup.instance).to eq FirstSetup.first
    end
  end
end
