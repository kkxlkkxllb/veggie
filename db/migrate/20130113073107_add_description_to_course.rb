class AddDescriptionToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :member_id, :integer
    add_column :courses, :description, :text
    add_column :courses, :status, :integer
    add_column :courses, :weight, :integer
    add_column :courses, :ctype, :integer
  end
end
