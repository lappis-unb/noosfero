require_dependency 'environment'

class Environment
  has_one :oauth_client_plugin_configs, :class_name => 'OauthClientPlugin::Config'
  has_many :oauth_providers, :class_name => 'OauthClientPlugin::Provider'
end
