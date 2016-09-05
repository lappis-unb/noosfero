Feature: profile fields block
  As an user
  I want to add a block to display my public fields

  Background:
  Given plugin ProfileFieldsBlock is enabled on environment
  Given the following Person fields are active fields
    | address       |
    | contact_phone |
    | description   |
  And I am logged in as admin
  And the following blocks
    | owner       | type                                          |
    | admin_user  | ProfileFieldsBlockPlugin::ProfileFieldsBlock  |

  Scenario: display only public fields to be added in the block
    Given the field address is public for all users
    And the field contact_phone is public for all users
    When I go to edit ProfileFieldsBlockPlugin::ProfileFieldsBlock of admin_user
    Then I should see "address"
    And I should see "contact_phone"
    And I should not see "description"

  Scenario: display field to be added in the block after turn it into public field
    Given I go to admin_user's control panel
    And I follow "Edit Profile"
    And I fill in "Description" with "My description"
    And I check "Public" within ".description"
    And I press "Save"
    When I go to edit ProfileFieldsBlockPlugin::ProfileFieldsBlock of admin_user
    And I should see "description"

  Scenario: display the content of choosen fields
    Given I go to admin_user's control panel
    And I follow "Edit Profile"
    And I fill in "Address" with "My address"
    And I check "Public" within ".address"
    And I press "Save"
    Given I go to edit ProfileFieldsBlockPlugin::ProfileFieldsBlock of admin_user
    And I check "address"
    And I press "Save"
    When I go to admin_user's homepage
    Then I should see "My address" within ".profile-fields-block-plugin_profile-fields-block"

  Scenario: no longer display a field that was turned into private
    Given the field address is public for all users
    Given I go to admin_user's control panel
    And I follow "Edit Profile"
    And I fill in "Address" with "My address"
    And I press "Save"
    Given I go to edit ProfileFieldsBlockPlugin::ProfileFieldsBlock of admin_user
    And I check "address"
    And I press "Save"
    When I go to admin_user's homepage
    Then I should see "My address" within ".profile-fields-block-plugin_profile-fields-block"
    Given I go to admin_user's control panel
    And I follow "Edit Profile"
    And I uncheck "Public" within ".address"
    And I press "Save"
    When I go to admin_user's homepage
    Then I should not see "My address" within ".profile-fields-block-plugin_profile-fields-block"

