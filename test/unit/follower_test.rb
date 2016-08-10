require_relative "../test_helper"

class FollowerTest < ActiveSupport::TestCase

  def setup
    @person1 = create_user('perso-test-1').person
    @person2 = create_user('person-test-2').person

    @circle1 = Circle.create!(owner: @person1, name: "Zombies", profile_type: 'Person')
    @circle2 = Circle.create!(owner: @person1, name: "Humans", profile_type: 'Person')
    @circle3 = Circle.create!(owner: @person1, name: "Crypt", profile_type: 'Community')

    @external_person = ExternalPerson.create!(identifier: 'johnlocke',
                                     name: 'John Locke',
                                     source: 'anerenvironment.org',
                                     email: 'locke@island.org',
                                     created_at: Date.yesterday)
  end

  should 'follows? return false when no profile is passed as parameter' do
    assert_equal false, @person1.follows?(nil)
  end

  should 'follow person with regular user' do
    assert_difference '@person1.followed_profiles.count' do
      @person1.follow(@person2, @circle1)
    end
    assert @person1.follows?(@person2)
  end

  should 'follow a community' do
    community = fast_create(Community)
    circle = Circle.create!(owner: @person1, name: "Terminus", profile_type: 'Community')

    assert_difference '@person1.followed_profiles.count' do
      @person1.follow(community, circle)
    end
    assert @person1.follows?(community)
  end

  should 'not follow person if the user is not the owner of the circle' do
    person3 = create_user('perso-test-3').person

    assert_no_difference '@circle1.owner.followed_profiles.count' do
      person3.follow(@person2, @circle1)
    end
    assert_not @circle1.owner.follows?(@person2)
  end

  should 'not follow a community if circle profile type does not match' do
    community = fast_create(Community)

    assert_no_difference '@person1.followed_profiles.count' do
      @person1.follow(community, @circle1)
    end
    assert_not @person1.follows?(community)
  end

  should 'follow person with external user' do
    @circle1.update_attributes(owner: @external_person)

    assert_difference '@external_person.followed_profiles.count' do
      @external_person.follow(@person2, @circle1)
    end
    assert @external_person.follows?(@person2)
  end

  should 'unfollow person with regular user' do
    @person1.follow(@person2, @circle1)

    assert_difference '@person1.followed_profiles.count', -1 do
      @person1.unfollow(@person2)
    end
    assert_not @person1.follows?(@person2)
  end

  should 'unfollow person with external user' do
    @circle1.update_attributes(owner: @external_person)
    @external_person.follow(@person2, @circle1)

    assert_difference '@external_person.followed_profiles.count', -1 do
      @external_person.unfollow(@person2)
    end
    assert_not @external_person.follows?(@person2)
  end

  should 'get the followed profiles for a regular user' do
    community = fast_create(Community)

    @person1.follow(@person2, @circle1)
    @person1.follow(@external_person, @circle1)
    @person1.follow(community, @circle3)
    assert_equivalent [@person2, @external_person, community],
                      @person1.followed_profiles
  end

  should 'get the followed profiles for an external user' do
    person3 = create_user('person-test-3').person
    community = fast_create(Community)
    @circle1.update_attributes(owner: @external_person)
    @circle3.update_attributes(owner: @external_person)

    @external_person.follow(@person2, @circle1)
    @external_person.follow(person3, @circle1)
    @external_person.follow(community, @circle3)
    assert_equivalent [@person2, person3, community],
                      @external_person.followed_profiles
  end

  should 'not follow same person twice even with different circles' do
    circle4 = Circle.create!(owner: @person1, name: "Free Folk", profile_type: 'Person')

    @person1.follow(@person2, @circle1)
    @person1.follow(@person2, @circle2)
    @person1.follow(@person2, circle4)
    assert_equivalent [@person2], @person1.followed_profiles
  end

  should 'display an error if a person is already being followed' do
    @person1.follow(@person2, @circle1)
    profile_follower = ProfileFollower.new(circle: @circle1, profile: @person2)

    profile_follower.valid?
    assert profile_follower.errors.messages[:profile_id].present?
  end

  should 'update profile circles for a person' do
    circle4 = Circle.create!(owner: @person1, name: "Brains", profile_type: 'Person')
    @person1.follow(@person2, [@circle1, @circle2])

    @person1.update_profile_circles(@person2, [@circle2, circle4])
    assert_equivalent [@circle2, circle4], @person2.circles
  end

  should 'keep other follower circles after update' do
    person3 = create_user('person-test-3').person
    circle4 = Circle.create!(owner: person3, name: "Humans", profile_type: 'Person')
    @person1.follow(@person2, @circle1)
    person3.follow(@person2, circle4)

    @person1.update_profile_circles(@person2, [@circle1, @circle2])
    assert_equivalent [@circle1, @circle2, circle4], @person2.circles
  end

  should 'remove a person from a circle' do
    @person1.follow(@person2, [@circle1, @circle2])

    @person1.remove_profile_from_circle(@person2, @circle2)
    assert @person2.in_circle? @circle1
    assert_not @person2.in_circle? @circle2
  end

  should 'not remove a person from a circle if the user is not the owner' do
    person3 = create_user('person-test-3').person
    @person1.follow(@person2, [@circle1, @circle2])

    person3.remove_profile_from_circle(@person2, @circle2)
    assert @person2.in_circle? @circle1
    assert @person2.in_circle? @circle2
  end

  should 'follow external profile' do
    external_profile = ExternalProfile.create
    @circle1.stubs(:profile_type).returns("ExternalProfile")

    assert_difference '@person1.followed_profiles.count' do
      @person1.follow(external_profile, @circle1)
    end
    assert @person1.follows? external_profile
    assert_equivalent [external_profile], @person1.followed_profiles
  end

  should 'unfollow external profile' do
    external_profile = ExternalProfile.create
    @circle1.stubs(:profile_type).returns("ExternalProfile")
    @person1.follow(external_profile, @circle1)

    assert_difference '@person1.followed_profiles.count', -1 do
      @person1.unfollow(external_profile)
    end
    assert_not @person1.follows?(@person2)
  end

end
