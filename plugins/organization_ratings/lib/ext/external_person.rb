require_dependency 'external_person'

class ExternalPerson
  has_many :organization_ratings, :as => :person
end
