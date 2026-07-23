class AddApprovedToUsers < ActiveRecord::Migration[8.0]
  def up
    add_column :users, :approved, :boolean, default: false
    # Everyone who existed before the approval flow keeps access.
    execute "UPDATE users SET approved = TRUE"
  end

  def down
    remove_column :users, :approved
  end
end
