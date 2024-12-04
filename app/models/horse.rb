class Horse < ApplicationRecord
  has_many :rides

  def as_json(options = {})
    # exclude create_at and update_at
    super(options.merge(except: [ :created_at, :updated_at ])).deep_symbolize_keys
  end

  def json_with_rides
    as_json(include: { rides: { except: [ :horse_id, :jockey_id, :owner_id, :trainer_id, :race_id, :created_at, :updated_at ] }  }, except: [ :created_at, :updated_at ])
  end
end
