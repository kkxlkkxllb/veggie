class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :title, :null => false
      t.string :content #官方词义
      t.string :source, :null => false, :default => "en"#词源类别 en/jp/zh-cn/etc.
      t.integer :level #难度等级 1最低，5最高
      t.timestamps
    end
  end
end
