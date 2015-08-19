require File.expand_path(File.dirname(__FILE__) + "/../../test_helper")

class GroupListBlockTest < ActiveSupport::TestCase

  def setup
    @profile = fast_create(Community)
    box = fast_create(Box, :owner_id => @profile.id, :owner_type => @profile.class.name)
    @block = create(WorkAssignmentPlugin::GroupListBlock, :box => box)
  end

  should "display work assignment group list block" do
    self.expects(:render).with(:file => 'blocks/group_list', :locals => { :block => @block })
    instance_eval(& @block.content)
  end

  should 'return all work assignemt groups in block' do
    work_assignment_group1 = WorkAssignmentPlugin::WorkAssignmentGroup.create!(:name => 'Group 1', :profile => @profile, :start_date => Time.now, :end_date => Time.now + 2.day)
    work_assignment_group2 = WorkAssignmentPlugin::WorkAssignmentGroup.create!(:name => 'Group 2', :profile => @profile, :start_date => Time.now, :end_date => Time.now + 2.day)

    assert_includes @block.all_groups, work_assignment_group1
    assert_includes @block.all_groups, work_assignment_group2
  end

  # FIX ME Refactor all_groups method
  should 'returns work assignment group list in descending order' do
    work_assignment_before = create_work_assignment_group('Group 1', @profile, Time.now, Time.now + 1.day)
    work_assignment_after = create_work_assignment_group('Group 2', @profile, Time.now, Time.now + 2.day)

    assert_equal @block.all_groups, [work_assignment_after, work_assignment_before]
  end

end