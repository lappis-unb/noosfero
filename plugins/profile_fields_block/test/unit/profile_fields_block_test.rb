require_relative '../test_helper'

class ProfileFieldsBlockTest < ActiveSupport::TestCase

  def setup
    @environment = Environment.default
    @block = ProfileFieldsBlockPlugin::ProfileFieldsBlock.create!
    @profile = create_user('testuser').person
    block.stubs(:owner).returns(profile)

    @c1 = CustomField.create!(
            name: "Blog1", format: "string", customized_type: "Person",
            active: true, required: true, environment: Environment.default)

    @c2 = CustomField.create!(
            name: "Blog2", format: "link", customized_type: "Person",
            active: true, required: true, environment: Environment.default)

    @cv1 = CustomFieldValue.create!(
            customized: profile, custom_field: @c1,
            value: "value", public: true)

    @cv2 = CustomFieldValue.create!(
            customized: profile, custom_field: @c2,
            value: "value", public: true)
  end

  attr_reader :environment, :block, :profile, :cv1, :cv2, :c2, :c2

  should 'describe itself' do
    assert_not_equal Block.description, block.class.description
    assert_equal 'Choose public fields from a profile to be displayed in a block.', block.class.description
  end

  should 'is editable' do
    assert block.editable?
  end

  should 'list profile public fields alphabeticaly ordered' do
    profile.stubs(:public_fields).returns(["phone", "email"])
    assert_equal ["email", "phone"], block.available_fields
  end

  should 'return empty array if any field is public' do
    assert_equal [], block.available_fields
  end

  should 'list profile public custom fields alphabeticaly ordered by' do
    assert_equal ({"Blog1" => "string", "Blog2" => "link"}), block.available_custom_fields
  end

  should 'return empty array if any custom field is public' do
    cv1.update_attributes!(public: false)
    cv2.update_attributes!(public: false)

    assert block.available_custom_fields.empty?
  end

  should 'retrieve fields hash data' do
    profile.stubs(:public_fields).returns(["description", "email"])
    profile.stubs(:description).returns("My description")

    block.fields = { "description" => "text" }

    expected = {
                :description => {:type => "text", :content => "My description"}
               }
    assert_equal expected, block.fields_data
  end

  should 'retrieve custom fields hash data' do
    block.custom_fields = { "Blog2" => "link" }

    expected = {
                :Blog2 => {:type => "link", :content => "value" },
               }
    assert_equal expected, block.fields_data
  end

  should 'not fetch data for fields that are no longer public' do
    profile.stubs(:description).returns("My description")
    profile.stubs(:public_fields).returns(["email"])

    block.fields = { "description" => "text" }
    #block.save!

    assert block.fields_data.empty?
  end

  should 'not fetch data for custom fields that are no longer public' do
    block.custom_fields = { "Blog1" => "link", "Blog2" => "link" }

    cv1.update_attributes!(public: false)
    cv2.update_attributes!(public: false)

    assert block.fields_data.empty?
  end

  should 'not break when custom field no longer exist' do
    block.custom_fields = { "Blog2" => "link", "Inexistent Custom Field" => "string" }
    assert_equal ({:Blog2 => { :type => "link", :content => "value" }}), block.fields_data
  end

end

