class AddTypeToExternalProfile < ActiveRecord::Migration
  def up
    add_column :external_profiles, :type, :string, default: "ExternalProfile"
  end

  def down
    remove_column :external_profiles, :type
  end
end
