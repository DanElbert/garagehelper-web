require 'rails_helper'

RSpec.describe GarageUpdate, :type => :model do

  describe '#different?' do

    it 'returns true for a nil param' do
      update = GarageUpdate.new
      expect(update.different?(nil)).to be_truthy
    end

    it 'returns true for a different param' do
      update = GarageUpdate.new(basement_door_open: true, big_door_open: true, back_door_open: true)
      other = GarageUpdate.new(basement_door_open: true, big_door_open: false, back_door_open: true)

      expect(update.different?(other)).to be_truthy
    end

    it 'returns false for a similar param' do
      update = GarageUpdate.new(basement_door_open: true, big_door_open: true, back_door_open: true)
      other = GarageUpdate.new(basement_door_open: true, big_door_open: true, back_door_open: true)

      expect(update.different?(other)).to be_falsey
    end

  end

end
