class CreateWorkAssignmentPluginFields < ActiveRecord::Migration
  def self.up
    add_column :articles, :begining, :datetime
    add_column :articles, :ending, :datetime
  end

  def self.down
    remove_column :articles, :begining
    remove_column :articles, :ending
  end
end
