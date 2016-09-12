class AddProfileTypeToSubmission < ActiveRecord::Migration
  def up
    add_column :custom_forms_plugin_submissions, :profile_type, :string, :default => "Profile"
    add_index :custom_forms_plugin_submissions, [:profile_id, :profile_type], :name => "submissions_profile_id_type"
  end

  def down
    remove_column :custom_forms_plugin_submissions, :profile_type, :string, :default => "Profile"
  end
end
