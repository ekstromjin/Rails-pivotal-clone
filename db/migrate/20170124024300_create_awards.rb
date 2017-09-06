class CreateAwards < ActiveRecord::Migration
  def change
    create_table :awards do |t|
      t.integer :story_id
      t.integer :user_id
      t.integer :points, :default => 0
    end
  end
end
