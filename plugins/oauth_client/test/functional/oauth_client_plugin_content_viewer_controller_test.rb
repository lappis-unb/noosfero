require 'test_helper'

class ContentViewerControllerTest < ActionController::TestCase

	def setup
		@community = Community.create(identifier: "mycommunity", name: "My Community")
		@community.blocks.each {|i| i.destroy}
		@community.boxes[0].blocks << ProfileInfoBlock.new
		@community.save!
		@article = TinyMceArticle.create!(:profile => @community, :name => 'An article whithin the community')
		@article.published = true
		@article.save!
	end

	should 'show allowed user actions for normal user' do
		@profile = create_user('foo').person
		login_as('foo')
		@article.stubs(:allow_spread?).with(@profile.user).returns(true)
		get :view_page, profile: @community.identifier, page: @article.slug
		assert_tag tag: "a", :descendant => {:tag => "span" , :child => /Spread this/ }
	end

end

