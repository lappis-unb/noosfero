class AddLdapLinkedToUser < ActiveRecord::Migration
  def change
    add_column :users, :ldap_linked, :boolean, default: false
  end
end
