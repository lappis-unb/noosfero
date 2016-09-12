class AddPersonTypeToRating < ActiveRecord::Migration
  def up
    add_column :organization_ratings, :person_type, :string, :default => 'Person'
    add_index :organization_ratings, [:person_id, :person_type]
  end

  def down
    remove_column :organization_ratings, :person_type
  end
end
