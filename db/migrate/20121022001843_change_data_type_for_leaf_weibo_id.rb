class ChangeDataTypeForLeafWeiboId < ActiveRecord::Migration
  def up
    change_table :leafs do |t|
      t.change :weibo_id, :string
    end
  end

  def down
    change_table :leafs do |t|
      t.change :weibo_id, :integer
    end
  end
end
