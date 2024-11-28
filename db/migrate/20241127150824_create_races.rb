class CreateRaces < ActiveRecord::Migration[7.2]
  def change
    create_table :races do |t|
      t.string :name
      t.string :age
      t.string :race_class
      t.string :distance
      t.string :date
      t.string :time
      t.string :off_time
      t.string :winning_time
      t.integer :ride_count
      t.string :going
      t.boolean :has_handicap
      t.references :meeting, null: false, foreign_key: true

      t.timestamps
    end
  end
end
