class Owner < ApplicationRecord
  has_many :rides

  def as_json(options = {})
    # exclude create_at and update_at
    super(options.merge(except: [ :created_at, :updated_at ])).deep_symbolize_keys
  end
end
