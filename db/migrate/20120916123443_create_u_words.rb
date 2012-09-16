class CreateUWords < ActiveRecord::Migration
  def change
    create_table :u_words do |t|
      t.integer :member_id, :null => false
      t.integer :word_id, :null => false
      t.string :content, :null => false, :default => ""
      t.timestamps
    end
  end
end
