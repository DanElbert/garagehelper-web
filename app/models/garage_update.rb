class GarageUpdate < ActiveRecord::Base

  scope :history, -> { where(is_change: true).order(created_at: :desc).limit(100) }

  # Returns a string describing what this event did, based on the state in the previous_update
  # Method assumes previous_update occurred earlier in time than this instance (and immediately before)
  def describe(previous_update)
    txt = ''
    [:basement_door_open?, :big_door_open?, :back_door_open?].each do |door|
      case
        when self.send(door) && !previous_update.send(door)
          add_txt(txt, "the #{door.to_s.sub('_open?', '').humanize} opened")
        when !self.send(door) && previous_update.send(door)
          add_txt(txt, "the #{door.to_s.sub('_open?', '').humanize} closed")
      end
    end
    if txt.present?
      {date: self.created_at, summary: txt }
    else
      nil
    end
  end

  def add_txt(base, txt)
    if base.empty?
      base << txt
    else
      base << ' and ' << txt
    end
  end

  def differences(other)
    list = []
    if other
      [:basement_door_open?, :big_door_open?, :back_door_open?].each do |door|
        list << door if !!self.send(door) != !!other.send(door)
      end
    end

    list
  end

  # returns true if other is nil or any of the door states are different between this instance and other
  def different?(other)
    !!differences(other).empty?
  end

  def self.summarize
    summary = []
    prev = nil
    self.history.to_a.reverse.each do |gu|
      unless prev.nil?
        summary << gu.describe(prev)
      end

      prev = gu
    end
    summary.compact.reverse
  end

end
