class AddIndexToUidAndRole < ActiveRecord::Migration
  def change
  	add_index(:members,[:role,:uid],:unique => true)
  end
end
