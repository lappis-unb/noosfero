class RenameExternalPeopleToExternalProfiles < ActiveRecord::Migration
  def up
    rename_table :external_people, :external_profiles
  end

  def down
    rename_table :external_profiles, :external_people
  end
end
