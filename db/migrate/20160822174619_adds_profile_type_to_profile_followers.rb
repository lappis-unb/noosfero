class AddsProfileTypeToProfileFollowers < ActiveRecord::Migration
  def up
    add_column :profiles_circles, :profile_type, :string, default: "Person"
    add_index :profiles_circles, [:profile_id, :profile_type]
  end

  def down
    remove_column :profiles_circles, :profile_type
    remove_index :profiles_circles, [:profile_id, :profile_type]
  end
end
