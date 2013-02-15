class AddGemToMember < ActiveRecord::Migration
  def change
  	add_column :members, :gem, :integer
  	add_column :u_words, :grasp, :boolean
  end
end
