class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :vote_field_id
      t.string :user_ip
      t.integer :user_id
      t.timestamps
    end
  end
end
