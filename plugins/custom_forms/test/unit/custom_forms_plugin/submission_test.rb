require 'test_helper'

class CustomFormsPlugin::SubmissionTest < ActiveSupport::TestCase
  def setup
    @profile = fast_create(Profile)
    @external_person = ExternalPerson.create!(identifier: 'externalze',
                                              name: 'External Ze',
                                              email: 'ze@external.com',
                                              source: 'external.noosfero.com',
                                              created_at: Date.today)
    @form = CustomFormsPlugin::Form.create!(:name => 'Free Software', :profile => @profile)
    @field = CustomFormsPlugin::Field.create!(:name => 'License', :form => @form)
  end
  attr_reader :profile, :external_person, :form, :field

  should 'validates presence of form' do
    submission = CustomFormsPlugin::Submission.new
    submission.valid?
    assert submission.errors.include?(:form)

    submission.form = form
    submission.valid?
    refute submission.errors.include?(:form)
  end

  should 'belong to a profile' do
    submission = CustomFormsPlugin::Submission.new
    submission.profile = profile
    assert_equal profile, submission.profile
  end

  should 'require presence of author name and email if profile is nil' do
    submission = CustomFormsPlugin::Submission.new
    submission.valid?
    assert submission.errors.include?(:author_name)
    assert submission.errors.include?(:author_email)

    submission.author_name = 'Jack Sparrow'
    submission.author_email = 'jack@black-pearl.com'
    submission.valid?
    refute submission.errors.include?(:author_name)
    refute submission.errors.include?(:author_email)
  end

  should 'have answers' do
    submission = CustomFormsPlugin::Submission.create!(:form => form, :profile => profile)
    a1 = submission.answers.create!(:field => field, :submission => submission)
    a2 = submission.answers.create!(:field => field, :submission => submission)

    assert_includes submission.answers, a1
    assert_includes submission.answers, a2
  end

  should 'store profile name as author' do
    submission = CustomFormsPlugin::Submission.create(:form => form, :profile => profile)

    assert_equal profile.name, submission.author_name
  end

  should 'submit anwser by external person' do
    submission = CustomFormsPlugin::Submission.create(:form => form, :profile => external_person)
    a1 = submission.answers.create!(:field => field, :submission => submission)

    assert_includes submission.answers, a1
  end
end

