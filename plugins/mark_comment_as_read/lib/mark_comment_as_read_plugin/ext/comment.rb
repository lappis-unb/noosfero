require_dependency 'comment'

class Comment

  has_many :read_comments, :class_name => 'MarkCommentAsReadPlugin::ReadComments'
  has_many :local_people, :through => :read_comments, :source_type => 'Profile', :source => 'person'
  has_many :external_people, :through => :read_comments, :source_type => 'ExternalPerson', :source => 'person'

  scope :marked_as_read_for, ->(person) {
    joins(:read_comments).where("person_id = ?", person.id)
  }

  def people
    self.local_people + self.external_people
  end

  def mark_as_read(person)
    MarkCommentAsReadPlugin::ReadComments.create(person: person, comment: self)
  end

  def mark_as_not_read(person)
    MarkCommentAsReadPlugin::ReadComments.find_by(person: person, comment: self).destroy
  end

  def marked_as_read?(person)
    person && (local_people.where(id: person.id).first.present? || external_people.where(id: person.id).first.present?)
  end

end
