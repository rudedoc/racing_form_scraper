class Meeting < ApplicationRecord
  has_many :races

  def as_json(options = {})
    super.merge(races: races.as_json).deep_symbolize_keys
  end
end
