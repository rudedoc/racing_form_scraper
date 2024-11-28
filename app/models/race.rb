class Race < ApplicationRecord
  belongs_to :meeting
  has_many :rides

  def as_json(options = {})
    super.merge(rides: rides.as_json).deep_symbolize_keys
  end
end
