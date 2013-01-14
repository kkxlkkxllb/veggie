class AddExpiredAtToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :expired_at, :datetime
  end
end
