class ContentTreePluginAdminController < AdminController
  def index
    @communities = Community.all
    @persons = Person.all
    @enterprises = Enterprise.all
  end
end