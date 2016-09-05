class ProfileFieldsBlockPlugin < Noosfero::Plugin

  def self.plugin_name
    # FIXME
    "ProfileFieldsBlockPlugin"
  end

  def self.extra_blocks
    {
      ProfileFieldsBlock  => { :type => [Community, Person, Enterprise] }
    }
  end

  def self.plugin_description
    # FIXME
    _("A plugin that adds a block to display profile fields information")
  end

  def stylesheet?
    true
  end

  def self.api_mount_points
    [ProfileFieldsBlockPlugin::API]
  end

end

