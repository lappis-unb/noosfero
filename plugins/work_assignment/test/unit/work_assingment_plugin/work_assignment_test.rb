require File.expand_path(File.dirname(__FILE__) + "/../../test_helper")

class WorkAssignmentTest < ActiveSupport::TestCase

  def setup
    @organization = fast_create(Organization)
    @work_assignment = create_work_assignment('Sample Work Assignment', @organization, nil, nil, Time.now, Time.now + 1.day)
  end

  should 'find or create sub-folder based on author identifier' do
    author = fast_create(Person)
    assert_nil @work_assignment.children.find_by_slug(author.identifier)

    folder = @work_assignment.find_or_create_author_folder(author)
    assert_not_nil @work_assignment.children.find_by_slug(author.identifier)
    assert_equal folder, @work_assignment.find_or_create_author_folder(author)
  end

  should 'return versioned name' do
    profile = fast_create(Profile)
    folder = fast_create(Folder, :profile_id => profile)
    a1 = Article.create!(:name => "Article 1", :profile => profile)
    a2 = Article.create!(:name => "Article 2", :profile => profile)
    a3 = Article.create!(:name => "Article 3", :profile => profile)
    klass = WorkAssignmentPlugin::WorkAssignment

    assert_equal "(V1) #{a1.name}", klass.versioned_name(a1, folder)

    a1.parent = folder
    a1.save!
    assert_equal "(V2) #{a2.name}", klass.versioned_name(a2, folder)

    a2.parent = folder
    a2.save!
    assert_equal "(V3) #{a3.name}", klass.versioned_name(a3, folder)
  end

  should 'move submission to its correct author folder' do
    author = fast_create(Person)
    submission = create(UploadedFile, :uploaded_data => fixture_file_upload('/files/rails.png', 'image/png'), :profile => @organization, :parent => @work_assignment, :author => author)

    author_folder = @work_assignment.find_or_create_author_folder(author)
    assert_equal author_folder, submission.parent
  end

  should 'add logged user on cache_key if is a member' do
    not_member = fast_create(Person)
    member = fast_create(Person)
    @organization.add_member(member)

    assert_no_match(/-#{not_member.identifier}/, @work_assignment.cache_key({}, not_member))
    assert_match(/-#{member.identifier}/, @work_assignment.cache_key({}, member))
  end

  should 'not be expired if today is between begining and ending' do
    assert_equal false, @work_assignment.expired?
  end

  should 'be expired if today is not between begining and ending' do
    @work_assignment.begining = Time.now - 2.day
    @work_assignment.ending = Time.now - 1.second

    assert_equal true, @work_assignment.expired?
  end

  should 'return status open if today is between begining and ending' do
    @work_assignment.ignore_time = false
    @work_assignment.save

    assert 'open', @work_assignment.status
  end

  should 'return status open if today isn\'t between begining and ending but ignore_time is enable' do
    @work_assignment.begining = Time.now - 1.day
    @work_assignment.ending = Time.now - 1.second
    @work_assignment.ignore_time = false
    @work_assignment.save

    assert 'allowed', @work_assignment.status
  end

  should 'return status expired if today is not between begining and ending' do
    @work_assignment.begining = Time.now - 1.day
    @work_assignment.ending = Time.now - 1.second
    @work_assignment.save

    assert 'expired', @work_assignment.status
  end


  should 'do not validate date period if begining is outside the group limit' do
    start_date = Time.now + 1.day
    end_date = Time.now + 2.day
    work_assignment_group = create_work_assignment_group('Work Assignment Group', @organization, start_date, end_date)

    @work_assignment.parent = work_assignment_group
    @work_assignment.validate_date.inspect
    assert @work_assignment.errors.any?
  end

  should 'do not validate date period if ending is outside the group limit' do
    start_date = Time.now - 1.day
    end_date = Time.now
    work_assignment_group = create_work_assignment_group('Work Assignment Group', @organization, start_date, end_date)

    @work_assignment.parent = work_assignment_group
    @work_assignment.validate_date.inspect
    assert @work_assignment.errors.any?
  end

end
