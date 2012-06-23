class CreateVoteFields < ActiveRecord::Migration
  def change
    create_table :vote_fields do |t|
      t.string :content
      t.integer :vote_subject_id
      t.timestamps
    end
  end
end
