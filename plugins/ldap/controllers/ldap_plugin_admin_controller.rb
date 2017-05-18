class LdapPluginAdminController < PluginAdminController

  append_view_path File.join(File.dirname(__FILE__) + '/../views')

  def index
  end

  def update
    if @environment.update(params[:environment])
      session[:notice] = _('LDAP configuration updated successfully.')
    else
      session[:notice] = _('LDAP configuration could not be saved.')
    end
    render :action => 'index'
  end

end

