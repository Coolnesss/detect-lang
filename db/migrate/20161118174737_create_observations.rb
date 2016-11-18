class CreateObservations < ActiveRecord::Migration
  def change
    create_table :observations do |t|
      t.text :code
      t.string :lang

      t.timestamps null: false
    end
  end
end
