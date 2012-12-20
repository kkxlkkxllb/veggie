class AddImageGeoToLeaf < ActiveRecord::Migration
  def change
    add_column :leafs, :width, :integer
    add_column :leafs, :height, :integer
    add_column :u_words, :width, :integer
    add_column :u_words, :height, :integer
  end
end
