require 'test_helper'
require_relative '../../controllers/custom_forms_plugin_profile_controller'

class CustomFormsPluginProfileControllerTest < ActionController::TestCase
  def setup
    @controller = CustomFormsPluginProfileController.new

    @profile = create_user('profile').person
    login_as(@profile.identifier)
    environment = Environment.default
    environment.enable_plugin(CustomFormsPlugin)

    @external_person = ExternalPerson.create!(identifier: 'externalze',
                                              name: 'External Ze',
                                              email: 'ze@external.com',
                                              source: 'external.noosfero.com',
                                              created_at: Date.today)

    @form = CustomFormsPlugin::Form.create!(:profile => profile, :name => 'Free Software')
    @field1 = CustomFormsPlugin::TextField.create(:name => 'Name', :form => @form, :mandatory => true)
    @field2 = CustomFormsPlugin::TextField.create(:name => 'License', :form => @form)
  end

  attr_reader :profile, :external_person, :form, :field1, :field2

  should 'save submission if fields are ok' do
    assert_difference 'CustomFormsPlugin::Submission.count', 1 do
      post :show, :profile => profile.identifier, :id => form.id, :submission => {field1.id.to_s => 'Noosfero', field2.id.to_s => 'GPL'}
    end
    refute session[:notice].include?('not saved')
    assert_redirected_to :action => 'show'
  end

  should 'save submission if fields are ok and user is external' do
    logout
    session[:external] = @external_person.id

    assert_difference 'CustomFormsPlugin::Submission.count', 1 do
      post :show, :profile => profile.identifier, :id => form.id, :submission => {field1.id.to_s => 'Noosfero'}
    end
    refute session[:notice].include?('not saved')
    assert_redirected_to :action => 'show'
  end

  should 'save submission if fields are ok and user is not logged in' do
    logout

    assert_difference 'CustomFormsPlugin::Submission.count', 1 do
      post :show, :profile => profile.identifier, :id => form.id, :author_name => "john", :author_email => 'john@example.com', :submission => {field1.id.to_s => 'Noosfero'}
    end
    assert_redirected_to :action => 'show'
  end

  should 'display errors if user is not logged in and author_name is not uniq' do
    logout
    submission = CustomFormsPlugin::Submission.create(:form => form, :author_name => "john", :author_email => 'john@example.com')

    assert_no_difference 'CustomFormsPlugin::Submission.count' do
      post :show, :profile => profile.identifier, :id => form.id, :author_name => "john", :author_email => 'john@example.com', :submission => {field1.id.to_s => 'Noosfero'}
    end
    assert_equal "Submission could not be saved", session[:notice]
    assert_tag :tag => 'div', :attributes => { :class => 'errorExplanation', :id => 'errorExplanation' }
  end

  should 'disable fields if form expired' do
    form.update_attributes :begining => Time.now + 1.day

    get :show, :profile => profile.identifier, :id => form.id
    assert_tag :tag => 'input', :attributes => {:disabled => 'disabled'}
  end

  should 'show expired message' do
    form.update_attributes :begining => Time.now + 1.day

    get :show, :profile => profile.identifier, :id => form.id
    assert_tag :tag => 'h2', :content => 'Sorry, you can\'t fill this form yet'

    form.begining = Time.now - 2.days
    form.ending = Time.now - 1.days
    form.save

    get :show, :profile => profile.identifier, :id => form.id
    assert_tag :tag => 'h2', :content => 'Sorry, you can\'t fill this form anymore'
  end
end
