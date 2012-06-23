class AddVideoToLeaf < ActiveRecord::Migration
  def change
    add_column :leafs, :video, :string
  end
end
