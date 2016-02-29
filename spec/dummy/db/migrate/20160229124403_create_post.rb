class CreatePost < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :text
      t.string :lang

      t.timestamps
    end
  end
end
