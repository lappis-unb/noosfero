class AddLdapUserToUser < ActiveRecord::Migration
  def change
    add_column :users, :ldap_user, :boolean, default: false
  end
end
