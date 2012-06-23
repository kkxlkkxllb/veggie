class CreateLeafs < ActiveRecord::Migration
  def change
    create_table :leafs do |t|
      t.text :content
      t.integer :provider_id
      t.string :image_url
      t.datetime :time_stamp
      t.integer :weibo_id

      t.timestamps
    end
  end
end
