class CreatePosiciones < ActiveRecord::Migration
  def change
    create_table :posiciones do |t|
      t.string :fecha, :null => false
      t.text :listado, :null => false

      t.timestamps
    end
    add_index :posiciones, :fecha
  end
end
