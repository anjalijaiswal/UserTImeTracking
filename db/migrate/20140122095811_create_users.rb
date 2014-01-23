class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.boolean :role

      t.timestamps
    end
  end
end
