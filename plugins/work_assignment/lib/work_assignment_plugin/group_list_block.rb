class WorkAssignmentPlugin::GroupListBlock < Block

  settings_items :limit, :type => :integer, :default => 3

  def self.description
    _('Work Assignment Group List')
  end

  def help
    _('This block displays a list of most relevant work assignment groups.')
  end

  #FIXME ORDER BY END_DATE
  def all_groups
    owner.articles.where(:type => 'WorkAssignmentPlugin::WorkAssignmentGroup').order('end_date DESC')
  end

  def content(args={})
    block = self
    proc do
      render :file => 'blocks/group_list', :locals => {:block => block}
    end
  end

end

