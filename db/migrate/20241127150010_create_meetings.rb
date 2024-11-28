class CreateMeetings < ActiveRecord::Migration[7.2]
  def change
    create_table :meetings do |t|
      t.string :name
      t.string :country_name
      t.string :going
      t.string :weather
      t.string :surface_summary
      t.date :date

      t.timestamps
    end
  end
end
