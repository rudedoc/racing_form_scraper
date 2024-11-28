class CreateJockeys < ActiveRecord::Migration[7.2]
  def change
    create_table :jockeys do |t|
      t.string :name

      t.timestamps
    end
  end
end
