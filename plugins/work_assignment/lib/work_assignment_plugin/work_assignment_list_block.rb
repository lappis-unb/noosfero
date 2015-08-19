class WorkAssignmentPlugin::WorkAssignmentListBlock < Block

  def self.description
    _('Recent Grade List')
  end

  def help
    _('This block displays a list of recent grades.')
  end

  def content(args={})
    block = self
    proc do
      render :file => 'blocks/recent_grades_list', :locals => {:block => block}
    end
  end

  def recent_grades(user)
    work = WorkAssignmentPlugin::WorkAssignment.all
    uploaded_file_array = []
    work.each do |w|
      folder = w.children.find_by_slug(user.name.to_slug)
      if folder && folder.author_id == user.id && w.publish_grades
        uploaded_file_array << folder.children
      end
    end
    uploaded_file_array = uploaded_file_array.flatten.select { |upload| upload.setting[:grade_version] == upload.parent.final_grade }
    uploaded_file_array.sort_by{|obj| obj.valuation_date}.reverse
  end

end
