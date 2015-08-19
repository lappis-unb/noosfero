Feature: display grade

  Background:
    Given "WorkAssignmentPlugin" plugin is enabled
    And I am logged in as admin
    And I go to /admin/plugins
    And I check "Work Assignment"
    And I press "Save changes"
    And the following users
      | login | name |
      | joaosilva | Joao Silva  |
      | mario     | Mario Souto |
      | maria     | Maria Silva |
    Given the following communities
      | name           | identifier    | owner     |
      | Free Software  | freesoftware  | joaosilva |
    And "Mario Souto" is a member of "Free Software"
    And "Maria Silva" is a member of "Free Software"
    And "joaosilva" has no articles
    And I am logged in as "joaosilva"

  @selenium
  Scenario: Can't view the column grade if Activate evaluation is unchecked
    Given I go to freesoftware's control panel
    And I follow "Manage Content"
    And I should see "New content"
    And I follow "New content"
    When I follow "Work Assignment"
    And I fill in "Title" with "Work Assignment title"
    And I check "Allow the sending of files after the period"
    And I press "Save"
    Then I should not see "Grade"

  @selenium
  Scenario: View the column grade if Activate evaluation is checked
    Given I go to freesoftware's control panel
    And I follow "Manage Content"
    And I should see "New content"
    And I follow "New content"
    When I follow "Work Assignment"
    And I fill in "Title" with "Work Assignment title"
    And I check "Allow the sending of files after the period"
    And I check "Activate evaluation"
    And I press "Save"
    And I follow "Upload files"
    And I attach the file "public/images/rails.png" to "uploaded_files_0"
    And I press "Upload"
    Then I should see "Grade"

  @selenium
  Scenario: View the final grade if the User owns the file
    Given I go to freesoftware's control panel
    And I follow "Manage Content"
    And I should see "New content"
    And I follow "New content"
    When I follow "Work Assignment"
    And I fill in "Title" with "Work Assignment title"
    And I check "Allow the sending of files after the period"
    And I check "Activate evaluation"
    And I check "Publish grade"
    And I press "Save"

    When I follow "Logout"
    And I am logged in as "maria"
    And I go to /freesoftware/work-assignment-title
    And I follow "Upload files"
    And I attach the file "public/images/rails.png" to "uploaded_files_0"
    And I press "Upload"

    When I follow "Logout"
    And I am logged in as "joaosilva"
    And I go to /freesoftware/work-assignment-title
    And I press "View all versions"
    And I follow "Assign"
    And I fill in "Grade" with "7"
    And I press "Assign Grade"

    When I follow "Logout"
    And I am logged in as "maria"
    And I go to /freesoftware/work-assignment-title
    Then I should see "7"

  @selenium
  Scenario: Can't view the final grade if the user owns the file
    Given I go to freesoftware's control panel
    And I follow "Manage Content"
    And I should see "New content"
    And I follow "New content"
    When I follow "Work Assignment"
    And I fill in "Title" with "Work Assignment title"
    And I check "Allow the sending of files after the period"
    And I check "Activate evaluation"
    And I check "Publish grade"
    And I press "Save"

    When I follow "Logout"
    And I am logged in as "maria"
    And I go to /freesoftware/work-assignment-title
    And I follow "Upload files"
    And I attach the file "public/images/rails.png" to "uploaded_files_0"
    And I press "Upload"

    When I follow "Logout"
    And I am logged in as "joaosilva"
    And I go to /freesoftware/work-assignment-title
    And I press "View all versions"
    And I follow "Assign"
    And I fill in "Grade" with "7"
    And I press "Assign Grade"

    When I follow "Logout"
    And I am logged in as "mario"
    And I go to /freesoftware/work-assignment-title
    Then I should not see "7"
