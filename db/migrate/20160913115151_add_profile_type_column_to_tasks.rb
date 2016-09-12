class AddProfileTypeColumnToTasks < ActiveRecord::Migration
  def up
    add_column :tasks, :requestor_type, :string, :default => 'Profile'
    add_index :tasks, [:requestor_id, :requestor_type]
  end

  def down
    remove_column :tasks, :requestor_type
  end
end
