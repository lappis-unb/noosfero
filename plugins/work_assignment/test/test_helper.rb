require 'test_helper'

def create_work_assignment(name = "text.txt", profile = nil, publish_submissions = nil, allow_visibility_edition = nil)
  @work_assignment = WorkAssignmentPlugin::WorkAssignment.create!(:name => name, :profile => profile, :publish_submissions => publish_submissions, :allow_visibility_edition => allow_visibility_edition)
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