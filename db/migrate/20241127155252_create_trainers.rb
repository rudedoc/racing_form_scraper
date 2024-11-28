class CreateTrainers < ActiveRecord::Migration[7.2]
  def change
    create_table :trainers do |t|
      t.string :name

      t.timestamps
    end
  end
end
