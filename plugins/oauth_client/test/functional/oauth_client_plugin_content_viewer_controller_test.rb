require 'test_helper'

class ContentViewerControllerTest < ActionController::TestCase

  def setup
    @community = Community.create(identifier: "mycommunity", name: "My Community")
    @external_person = ExternalPerson.create(identifier: "ze1",
                                             name: "ze",
                                             source: "zeenvironment.org",
                                             email: "ze@mail.com",
                                             created_at: Date.yesterday)
    @profile = create_user('foo').person
  end

  should 'show allowed user actions for normal user' do
    @community = Community.create(:name => 'testcomm')
    @community.articles.create!(:name => 'myarticle', :body => 'test article', :published => true)
    login_as('foo')
    get :view_page, :profile => @community.identifier, :page => ['myarticle']
    assert_tag tag: "a", attributes: {:class => "modal-toggle button with-text icon-spread"}
  end

  should 'show hide user actions for external user' do
    session[:external] = @external_person.id
    @community.articles.create!(:name => 'myarticle', :body => 'test article', :published => true)
    get :view_page, :profile => @community.identifier, :page => ['myarticle']
    assert_no_tag tag: "a", attributes: {:class => "modal-toggle button with-text icon-spread"}
  end


end

