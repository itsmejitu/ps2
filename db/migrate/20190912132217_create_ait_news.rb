class CreateAitNews < ActiveRecord::Migration[5.2]
  def change
    create_table :ait_news do |t|
      t.string :title
      t.text :url
      t.text :image

      t.timestamps
    end
  end
end
