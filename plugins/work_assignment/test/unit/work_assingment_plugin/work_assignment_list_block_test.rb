require File.expand_path(File.dirname(__FILE__) + "/../../test_helper")

class WorkAssignmentListBlockTest < ActiveSupport::TestCase

  def setup
    @person = create_user('test_user').person
    @organization = fast_create(Community)
    box = fast_create(Box, :owner_id => @organization.id, :owner_type => @organization.class.name)
    @block = create(WorkAssignmentPlugin::WorkAssignmentListBlock, :box => box)
  end

  should 'return recent grades' do
    @organization.add_member(@person)
    work_assignment = create_work_assignment('Work Assignment', @organization, nil, true, nil, nil, true, true)
    folder = work_assignment.find_or_create_author_folder(@person)
    file = create_uploaded_file("file.txt", @organization, folder, @person, @person, true)
    file2 = create_uploaded_file("file2.txt", @organization, folder, @person, @person, true)

    file.grade_version = 7
    file.valuation_date = Time.now
    file.save!

    folder.reload

    assert_includes @block.recent_grades(@person), file
    assert_not_includes @block.recent_grades(@person), file2
  end

end