class AddProfileTypeToReadCommentsTable < ActiveRecord::Migration
  def up
		add_column :mark_comment_as_read_plugin, :person_type, :string
		add_index :mark_comment_as_read_plugin, [:person_type, :person_id], name: 'read_comments_person'
  end

	def down
		remove_column :mark_comment_as_read_plugin, :person_type
	end
end
