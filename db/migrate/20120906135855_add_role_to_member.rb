class AddRoleToMember < ActiveRecord::Migration
  def change
    add_column :members, :role, :string
    add_column :members, :uid, :string
  end
end
