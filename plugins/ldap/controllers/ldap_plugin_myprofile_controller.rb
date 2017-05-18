require_relative '../lib/ldap_authentication.rb'
require_relative '../lib/ldap_plugin.rb'

class LdapPluginMyprofileController < MyProfileController
  
  append_view_path File.join(File.dirname(__FILE__) + '/../views')

  def index
    return render_access_denied unless current_person.has_permission? 'edit_profile', profile

    if profile.person? && profile.user.ldap_user
      return redirect_to :controller => :home
    end

    if request.post?
      target_user = profile.user
      login = params[:user][:login]
      password = params[:user][:password]
      ldap = LdapAuthentication.new(environment.ldap_plugin_attributes)
      ldap_plugin = LdapPlugin.new

      # try to authenticate
      begin
        attrs = ldap.authenticate(login, password)
        unless attrs.nil?
          ldap_user = User.find_by(login: login)
          unless ldap_user.nil?
            unless ldap_user.ldap_linked
              ldap_user.login = ldap_user.login + "_old"
              ldap_user.save!
              link_ldap_account(target_user, login, password)
              session[:notice] = _('Account successfully linked.')
              redirect_to :controller => :home
            else
              session[:notice] = _('Cannot complete the operation. %s account already linked.') % environment.ldap_plugin_base_name
            end
          else
            session[:notice] = _('Account successfully linked.')
            link_ldap_account(target_user, login, password)
            redirect_to :controller => :home
          end
        else
          session[:notice] = _('Cannot complete the operation. %s account does not exist.') % environment.ldap_plugin_base_name
        end
      rescue Net::LDAP::Error => e
        logger.warn("LDAP is not configured correctly!!")
        session[:notice] = _('Error authenticating in %s. Contact an administrator.') % environment.ldap_plugin_base_name
      end


    end
  end

private

  def link_ldap_account(current_user, ldap_login, ldap_password)
    current_user.ldap_user = true
    current_user.ldap_linked = true
    current_user.login = ldap_login
    current_user.password = ldap_password
    current_user.password_confirmation = ldap_password
    current_user.save!
  end
end

