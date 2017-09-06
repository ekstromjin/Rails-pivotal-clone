class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :firstname
      t.string :lastname
      t.string :email, :null => false
      t.string :password
      t.integer :gender, :default => 0, :null => false
      t.date :birthdate
      t.integer :role
      t.string :avatar_url
      t.string  :activate_key
      t.integer :is_activate, :default => 0
      t.timestamps null: false
    end
  end
end
