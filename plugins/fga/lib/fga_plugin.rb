class FgaPlugin < Noosfero::Plugin

  def self.plugin_name
    "FgaPlugin"
  end

  def self.plugin_description
    _("Plugin for the FGA Portal.")
  end

  def self.extra_blocks
    {
      TccBlock => {:type => [Environment, Community]}
    }
  end

end
