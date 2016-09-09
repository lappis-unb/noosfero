require 'test_helper'
require_relative '../../controllers/mark_comment_as_read_plugin_profile_controller'

class MarkCommentAsReadPluginProfileControllerTest < ActionController::TestCase
  def setup
    @controller = MarkCommentAsReadPluginProfileController.new

    @profile = create_user('profile').person
    @external_person = ExternalPerson.create!(identifier: 'externalze',
                                              name: 'External Ze',
                                              source: 'anerenvironment.org',
                                              email: 'external@ze.org',
                                              created_at: Date.yesterday)
    @article = TinyMceArticle.create!(:profile => @profile, :name => 'An article')
    @comment = Comment.create(:source => @article, :author => @profile, :body => 'test')
    environment = Environment.default
    environment.enable_plugin(MarkCommentAsReadPlugin)
  end

  attr_reader :profile, :external_person, :comment

  should 'mark comment as read' do
    login_as(profile.identifier)

    xhr :post, :mark_as_read, :profile => profile.identifier, :id => comment.id
    assert_match /\{\"ok\":true\}/, @response.body
    assert comment.marked_as_read? profile
  end

  should 'mark comment as not read' do
    login_as(profile.identifier)
    comment.mark_as_read(profile)

    xhr :post, :mark_as_not_read, :profile => profile.identifier, :id => comment.id
    assert_match /\{\"ok\":true\}/, @response.body
  end

  should 'mark comment as read when logged in with external person' do
    session[:external] = external_person.id

    xhr :post, :mark_as_read, :profile => profile.identifier, :id => comment.id
    assert_match /\{\"ok\":true\}/, @response.body
    assert comment.marked_as_read? external_person
  end

  should 'mark comment as not read when logged in with external person' do
    session[:external] = external_person.id
    comment.mark_as_read(external_person)

    xhr :post, :mark_as_not_read, :profile => profile.identifier, :id => comment.id
    assert_match /\{\"ok\":true\}/, @response.body
  end
end
