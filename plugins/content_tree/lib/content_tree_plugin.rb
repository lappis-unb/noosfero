class ContentTreePlugin < Noosfero::Plugin

  def self.plugin_name
    # FIXME
    "ContentTreePlugin"
  end

  def self.plugin_description
    # FIXME
    _("A plugin that does this and that.")
  end

  def stylesheet?
    true
  end

  def js_files
    %w(
      javascripts/style.js
    )
  end

end
