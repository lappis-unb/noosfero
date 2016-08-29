require 'test_helper'

class ProfileControllerTest < ActionController::TestCase

	def	setup
		@community = Community.create(identifier: "mycommunity", name: "My Community")
		@community.blocks.each {|i| i.destroy}
		@community.boxes[0].blocks << ProfileInfoBlock.new
		@community.save!
		@person = create_user('bar').person
		@person.blocks.each {|i| i.destroy}
		@person.boxes[0].blocks << ProfileInfoBlock.new
		@person.save!
		@external_person = ExternalPerson.create(identifier: "ze1",
																						name: "ze",
																						source: "zeenvironment.org",
																						email: "ze@mail.com",
																						created_at: Date.yesterday)
	end

  should 'hide not allowed community actions for external user' do
		session[:external] = @external_person.id
    get :index, profile: @community.identifier
		assert_no_tag tag: "a", :attributes => {:title => "Join this community" }
		assert_no_tag tag: "a", :attributes => {:title => "Send an e-mail to the administrators" }
		assert_tag tag: "a", :attributes => {:title => "Follow" }
  end

  should 'hide not allowed user actions for external user' do
		session[:external] = @external_person.id
    get :index, profile: @external_person.identifier
		assert_no_tag tag: "a", :attributes => {:title => "Add friend" }
  end

  should 'show allowed user actions for normal user' do
		create_user('foo').person
		login_as('foo')
    get :index, profile: @person.identifier
		assert_tag tag: "a", :attributes => {:title => "Add friend" }
  end

  should 'show allowed actions for normal user' do
		create_user('foo').person
		login_as('foo')
    get :index, profile: @community.identifier
		assert_tag tag: "a", :attributes => {:title => "Join this community" }
		assert_tag tag: "a", :attributes => {:title => "Send an e-mail to the administrators" }
		assert_tag tag: "a", :attributes => {:title => "Follow" }
  end
	
end
