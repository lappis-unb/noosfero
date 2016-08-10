require_relative "../test_helper"

class FollowableTest < ActiveSupport::TestCase

  def setup
    @person1 = create_user('perso-test-1').person
    @person2 = create_user('person-test-2').person
    @external_person = ExternalPerson.create!(identifier: 'johnlocke',
                                     name: 'John Locke',
                                     source: 'anerenvironment.org',
                                     email: 'locke@island.org',
                                     created_at: Date.yesterday)

    @circle1 = Circle.create!(owner: @person1, name: "Zombies", profile_type: 'Person')
    @circle2 = Circle.create!(owner: @person1, name: "Humans", profile_type: 'Person')
    @circle3 = Circle.create!(owner: @external_person, name: "Crypt", profile_type: 'Person')

    @external_profile = ExternalProfile.create
  end

  should 'return all unique circles and followers of a profile' do
    @person1.follow(@person2, @circle1)
    @person1.follow(@person2, @circle2)
    @external_person.follow(@person2, @circle3)

    assert_equivalent [@circle1, @circle2, @circle3], @person2.circles
    assert_equivalent [@person1, @external_person], @person2.followers
  end

  should 'return all unique circles and followers of a external profile' do
    Circle.any_instance.stubs(:profile_type).returns("ExternalProfile")
    @person1.follow(@external_profile, @circle1)
    @person1.follow(@external_profile, @circle2)
    @external_person.follow(@external_profile, @circle3)

    assert_equivalent [@circle1, @circle2, @circle3], @external_profile.circles
    assert_equivalent [@person1, @external_person], @external_profile.followers
  end

  should 'onlyreturn true if profile is in circle' do
    @person1.follow(@person2, @circle1)
    @external_person.follow(@person2, @circle3)

    assert @person2.in_circle? @circle1
    assert @person2.in_circle? @circle3
    refute @person2.in_circle? @circle2
  end

  should 'only return true if external profile is in circle' do
    Circle.any_instance.stubs(:profile_type).returns("ExternalProfile")
    @person1.follow(@external_profile, @circle1)
    @external_person.follow(@external_profile, @circle3)

    assert @external_profile.in_circle? @circle1
    assert @external_profile.in_circle? @circle3
    refute @external_profile.in_circle? @circle2
  end

end
