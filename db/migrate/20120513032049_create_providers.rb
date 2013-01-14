class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.string :provider,  :null => false
      t.string :uid,       :null => false
      t.string :token
      t.string :secret
      t.text :metadata
      t.integer :user_id

      t.timestamps
    end
  end
end
