class OauthClientPlugin::Config < ApplicationRecord

  belongs_to :environment
  attr_accessible :allow_external_login, :environment_id

  class << self
    def instance
      environment = Environment.default
      environment.oauth_client_plugin_configs || create(environment_id: environment.id)
    end

    private :new
  end

end
