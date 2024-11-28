class CreateRides < ActiveRecord::Migration[7.2]
  def change
    create_table :rides do |t|
      t.integer :finish_position
      t.string :ride_status
      t.string :handicap
      t.text :headgear, array: true, default: []
      t.integer :official_rating
      t.float :jockey_claim
      t.text :ride_description
      t.text :commentary
      t.string :betting, array: true, default: []
      t.references :horse, null: false, foreign_key: true
      t.references :jockey, null: false, foreign_key: true
      t.references :trainer, null: false, foreign_key: true
      t.references :owner, null: false, foreign_key: true
      t.references :race, null: false, foreign_key: true
      t.string :casualty
      t.string :insights, array: true, default: []
      t.integer :horse_lifetime_stats_run_count
      t.integer :horse_lifetime_stats_win_count
      t.integer :horse_lifetime_stats_place_count

      t.timestamps
    end
  end
end
