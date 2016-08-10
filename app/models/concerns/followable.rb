module Followable
  extend ActiveSupport::Concern

  included do
    has_many :profile_followers, :as => :profile
    has_many :circles, :through => :profile_followers
  end

  def followers
    person_followers = Person.joins(:owned_circles).merge(circles).uniq
    external_person_followers = ExternalPerson.joins(:owned_circles).merge(circles).uniq

    person_followers + external_person_followers
  end

  def followed_by?(person)
    (person == self) || (person.in? self.followers)
  end

  def in_circle?(circle)
    circle.in? self.circles
  end
end
