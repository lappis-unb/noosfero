class MarkCommentAsReadPlugin::ReadComments < ApplicationRecord
  self.table_name = 'mark_comment_as_read_plugin'
  belongs_to :comment
  belongs_to :person, polymorphic: true

  validates_presence_of :comment, :person
end
