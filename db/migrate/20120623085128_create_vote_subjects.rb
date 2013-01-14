class CreateVoteSubjects < ActiveRecord::Migration
  def change
    create_table :vote_subjects do |t|
      t.string :title         # 标题
      t.integer :key_id       # option 答案选项id
      t.datetime :end_time    # option 截止时间
      t.integer :limit_num    # option 限定票数
      t.timestamps
    end
  end
end
