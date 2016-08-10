class RenamePersonIdFromCircles < ActiveRecord::Migration
  def up
    rename_column :circles, :person_id, :owner_id
    rename_column :circles, :person_type, :owner_type
  end

  def down
    rename_column :circles, :owner_id, :person_id
    rename_column :circles, :owner_type, :person_type
  end
end
