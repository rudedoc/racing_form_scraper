class CreateHorses < ActiveRecord::Migration[7.2]
  def change
    create_table :horses do |t|
      t.string :name
      t.integer :age
      t.date :foaled
      t.string :sex

      t.timestamps
    end
  end
end
