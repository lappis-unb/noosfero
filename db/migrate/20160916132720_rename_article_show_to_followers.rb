class RenameArticleShowToFollowers < ActiveRecord::Migration
  def change
    rename_column :articles, :show_to_followers, :show_to_members_and_friends
  end
end
