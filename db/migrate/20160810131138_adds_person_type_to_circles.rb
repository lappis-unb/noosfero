class AddsPersonTypeToCircles < ActiveRecord::Migration
  def up
    add_column :circles, :person_type, :string, default: "Person"
    add_index :circles, [:person_id, :person_type]
  end

  def down
    remove_column :circles, :person_type
    remove_index :circles, [:person_id, :person_type]
  end
end
