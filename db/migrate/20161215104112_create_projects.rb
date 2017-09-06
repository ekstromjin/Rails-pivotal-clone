class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.date :startdate
      t.date :estimatedenddate
      t.integer :security
      t.string :img_url
      t.timestamps null: false
    end
  end
end
