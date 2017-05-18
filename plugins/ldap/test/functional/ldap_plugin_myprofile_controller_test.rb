require_relative '../test_helper'
require_relative '../../controllers/ldap_plugin_myprofile_controller'

class LdapPluginMyprofileControllerTest < ActionController::TestCase

  def setup
    @environment = Environment.default

    login_user = create_admin_user(@environment)
    login_as(login_user)
    @logged_user = User[login_user]

    @ldap_config = load_ldap_config
    @environment.enabled_plugins = ['LdapPlugin']
    @environment.ldap_plugin = @ldap_config['server'] unless @ldap_config.nil?
    @environment.ldap_plugin.stringify_keys!
    @environment.ldap_plugin_base_name = "LDAP"
    @environment.save!
  end

  attr_accessor :admin

  should 'access index action' do
    get :index, profile: @logged_user.person.identifier
    assert_template 'index'
    assert_response :success
  end

  if ldap_configured?
    should 'link a noosfero account with a never logged LDAP account' do
      post :index, profile: @logged_user.person.identifier, :user => {:login => @ldap_config['user']['login'], :password => @ldap_config['user']['password']}
      
      user = User.find_by_id(@logged_user.id)
      
      assert_equal 'Account successfully linked.', @request.session[:notice]
      assert_equal user.login, @ldap_config['user']['login']
    end

    should 'link a noosfero account with an already logged but never linked LDAP account' do
      user = create_user(@ldap_config['user']['login'], :email => @ldap_config['user']['email'], :password => @ldap_config['user']['password'], :password_confirmation => @ldap_config['user']['password'])
      user.ldap_user = true
      user.ldap_linked = false
      user.activate
      user.save!
      post :index, profile: @logged_user.person.identifier, :user => {:login => user.login, :password => @ldap_config['user']['password']}
      user = User.find_by_id(@logged_user.id)

      assert_equal 'Account successfully linked.', @request.session[:notice]
      assert_equal user.login, @ldap_config['user']['login']
    end

    should 'not link a noosfero account with an inexistent LDAP account' do
      post :index, profile: @logged_user.person.identifier, :user => {:login => 'jucabala', :password => 'ronaldinho'}
      assert_equal 'Cannot complete the operation. LDAP account does not exist.', @request.session[:notice]
    end

    should 'not link a noosfero account with an already linked LDAP account' do
      user = create_user(@ldap_config['user']['login'], :email => @ldap_config['user']['email'], :password => @ldap_config['user']['password'], :password_confirmation => @ldap_config['user']['password'])
      user.ldap_user = true
      user.ldap_linked = true
      user.activate
      user.save!
      post :index, profile: @logged_user.person.identifier, :user => {:login => @ldap_config['user']['login'], :password => @ldap_config['user']['password']}
      assert_equal 'Cannot complete the operation. LDAP account already linked.', @request.session[:notice]
    end

    should 'redirect to root if target user is a LDAP user' do
      @logged_user.ldap_user = true
      @logged_user.ldap_linked = true
      post :index, profile: @logged_user.person.identifier, :user => {:login => @ldap_config['user']['login'], :password => @ldap_config['user']['password']}
      assert_redirected_to :root
    end

    should 'return an access denied when trying to update another profile' do
      user = create_user(@ldap_config['user']['login'], :email => @ldap_config['user']['email'], :password => @ldap_config['user']['password'], :password_confirmation => @ldap_config['user']['password'])
      user.ldap_user = true
      user.ldap_linked = true
      user.activate
      user.save!
      post :index, profile: user.person.identifier, :user => {:login => @ldap_config['user']['login'], :password => @ldap_config['user']['password']}
      assert_template 'shared/access_denied'
    end
  else
    puts LDAP_SERVER_ERROR_MESSAGE
  end
end
