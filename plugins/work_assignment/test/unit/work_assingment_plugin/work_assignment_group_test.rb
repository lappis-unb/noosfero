require File.expand_path(File.dirname(__FILE__) + "/../../test_helper")

class WorkAssignmentGroupTest < ActiveSupport::TestCase

  def setup
    @organization = fast_create(Organization)
    start_date = Time.now
    end_date = Time.now + 2.day
    @work_assignment_group = create_work_assignment_group('Work Assignment Group', @organization, start_date, end_date)
    @work_assignment = create_work_assignment('Sample Work Assignment', @organization, nil, nil, Time.now, Time.now + 1.day)
  end

  should 'return children work assignment' do
    @work_assignment.parent = @work_assignment_group
    @work_assignment.save!
    assert_equal [@work_assignment], @work_assignment_group.work_assignment_list
  end

  should 'not be expired if today is between start and end dates' do
    assert_equal false, @work_assignment_group.expired?
  end

  should 'be expired if today is not between start and end dates' do
    @work_assignment_group.start_date = Time.now - 2.day
    @work_assignment_group.end_date = Time.now - 1.second
    @work_assignment_group.save

    assert_equal true, @work_assignment_group.expired?
  end

  should 'return status open if today is between start and end dates' do
    assert_equal 'open', @work_assignment_group.status
  end

  should 'return status expired if today is not between start and end dates' do
    @work_assignment_group.start_date = Time.now - 2.day
    @work_assignment_group.end_date = Time.now - 1.second
    @work_assignment_group.save

    assert_equal 'expired', @work_assignment_group.status
  end

end
