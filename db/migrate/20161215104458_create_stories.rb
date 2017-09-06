class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string :title
      t.integer :status
      t.integer :project_id
      t.integer :points
      t.text :description
      t.integer :story_type
      t.integer :award_began, :default => 0
      t.timestamps null: false
    end
  end
end
