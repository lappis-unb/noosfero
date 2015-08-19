require File.expand_path(File.dirname(__FILE__) + "/../../../test/test_helper")

  def create_work_assignment_group(name = 'Group', profile = nil, start_date = Time.now, end_date = Time.now + 2.day)
    @work_assignment_group = WorkAssignmentPlugin::WorkAssignmentGroup.create!(:name => name, :profile => profile, :start_date => start_date, :end_date => end_date)
  end

  def create_work_assignment(name = "text.txt", profile = nil, publish_submissions = nil, allow_visibility_edition = nil, begining = Time.now, ending = Time.now + 1.day, work_assignment_activate_evaluation = nil, publish_grades = nil, ignore_time = false)
    @work_assignment = WorkAssignmentPlugin::WorkAssignment.create!(:name => name, :profile => profile, :publish_submissions => publish_submissions, :allow_visibility_edition => allow_visibility_edition, :begining => begining, :ending => ending, :publish_grades => publish_grades, :work_assignment_activate_evaluation => work_assignment_activate_evaluation, :ignore_time => ignore_time)
  end

  def create_uploaded_file(name_slug = nil, profile = nil, parent = nil, last_changed_by= nil, author = nil, protection_type = nil)
    UploadedFile.create!(
          {
            :name => name_slug,
            :slug => name_slug,
            :uploaded_data => fixture_file_upload("files/test.txt", 'text/plain'),
            :profile => profile,
            :parent => parent,
            :last_changed_by => last_changed_by,
            :author => author,
          },
          :without_protection => protection_type
        )
  end
