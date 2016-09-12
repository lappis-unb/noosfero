require_dependency 'person'

Person.class_eval do
  has_many :organization_ratings, :as => :person
end
