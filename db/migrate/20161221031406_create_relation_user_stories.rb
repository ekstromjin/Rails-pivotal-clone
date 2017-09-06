class CreateRelationUserStories < ActiveRecord::Migration
  def change
    create_table :relation_user_stories do |t|
      t.integer :user_id
      t.integer :story_id
      t.timestamps null: false
    end
  end
end
