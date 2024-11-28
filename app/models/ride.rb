class Ride < ApplicationRecord
  belongs_to :horse
  belongs_to :jockey
  belongs_to :trainer
  belongs_to :owner
  belongs_to :race
end
