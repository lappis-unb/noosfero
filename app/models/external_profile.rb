class ExternalProfile < ApplicationRecord

  include Followable

  SEARCHABLE_FIELDS = {
    :name => {:label => _('Name'), :weight => 10},
    :identifier => {:label => _('Username'), :weight => 5},
    :nickname => {:label => _('Nickname'), :weight => 2},
  }

  def name
    "#{self[:name]}@#{self.source}"
  end

  class ExternalProfile::Image
    def initialize(path)
      @path = path
    end

    def public_filename(size = nil)
      URI.join(@path, size.to_s)
    end

    def content_type
      # This is not really going to be used anywhere that matters
      # so we are hardcodding it here.
      'image/png'
    end
  end

  def url
    "http://#{self.source}/profile/#{self.identifier}"
  end

  def image
    ExternalProfile::Image.new(avatar)
  end

  def profile_custom_icon(gravatar_default=nil)
    self.avatar
  end

  def avatar
    "http://#{self.source}/profile/#{self.identifier}/icon/"
  end

  # External Profile should respond to all methods in Profile
def profile_instance_methods
    methods_and_responses = {
     role_assignments: RoleAssignment.none, favorite_enterprises:
     Enterprise.none, memberships: Profile.none, friendships: Profile.none,
     tasks: Task.none, suggested_profiles: ProfileSuggestion.none,
     suggested_people: ProfileSuggestion.none, suggested_communities:
     ProfileSuggestion.none, public_profile: true, nickname: nil, custom_footer:
     '', custom_header: '', address: '', zip_code: '', contact_phone: '',
     image_builder: nil, description: '', closed: false, template_id: nil, lat:
     nil, lng: nil, is_template: false, fields_privacy: {}, preferred_domain_id:
     nil, category_ids: [], country: '', city: '', state: '',
     national_region_code: '', redirect_l10n: false, notification_time: 0,
     custom_url_redirection: nil, email_suggestions: false,
     allow_members_to_invite: false, invite_friends_only: false, secret: false,
     profile_admin_mail_notification: false, redirection_after_login: nil,
     profile_activities: ProfileActivity.none, action_tracker_notifications:
     ActionTrackerNotification.none, tracked_notifications:
     ActionTracker::Record.none, scraps_received: Scrap.none, template:
     Profile.none, comments_received: Comment.none, email_templates:
     EmailTemplate.none, members: Profile.none, members_like: Profile.none,
     members_by: Profile.none, members_by_role: Profile.none, scraps:
     Scrap.none, welcome_page_content: nil, settings: {}, find_in_all_tasks:
     nil, top_level_categorization: {}, interests: Category.none, geolocation:
     '', country_name: '', pending_categorizations: [], add_category: false,
     create_pending_categorizations: false, top_level_articles: Article.none,
     valid_identifier: true, valid_template: false, create_default_set_of_boxes:
     true, copy_blocks_from: nil, default_template: nil,
     template_without_default: nil, template_with_default: nil, apply_template:
     false, iframe_whitelist: [], recent_documents: Article.none, last_articles:
     Article.none, is_validation_entity?: false, hostname: nil, own_hostname:
     nil, article_tags: {}, tagged_with: Article.none,
     insert_default_article_set: false, copy_articles_from: true,
     copy_article_tree: nil, copy_article?: false, add_member: false,
     remove_member: false, add_admin: false, remove_admin: false, add_moderator:
     false, display_info_to?: true, update_category_from_region: nil,
     accept_category?: false, custom_header_expanded: '',
     custom_footer_expanded: '', public?: true, themes: [], find_theme: nil,
     blogs: Blog.none, blog: nil, has_blog?: false, forums: Forum.none, forum:
     nil, has_forum?: false, admins: [], settings_field: {}, setting_changed:
     false, public_content: true, enable_contact?: false, folder_types: [],
     folders: Article.none, image_galleries: Article.none, image_valid: true,
     update_header_and_footer: nil, update_theme: nil, update_layout_template:
     nil, recent_actions: ActionTracker::Record.none, recent_notifications:
     ActionTracker::Record.none, more_active_label: _('no activity'),
     more_popular_label: _('no members'), profile_custom_image: nil,
     is_on_homepage?: false, activities: ProfileActivity.none,
     may_display_field_to?: true, may_display_location_to?: true, public_fields:
     {}, display_private_info_to?: true, can_view_field?:
     true, remove_from_suggestion_list: nil, layout_template: 'default',
     is_admin?: false, add_friend: false, is_a_friend?: false,
     already_request_friendship?: false, tracked_actions: ActionTracker::Record.none
    }

    derivated_methods = generate_derivated_methods(methods_and_responses)
    derivated_methods.merge(methods_and_responses)
  end

  def method_missing(method, *args, &block)
    if profile_instance_methods.keys.include? method
      return profile_instance_methods[method]
    end
    raise NoMethodError, "undefined method #{method} for #{self}"
  end

  def respond_to_missing?(method_name, include_private = false)
    profile_instance_methods.keys.include?(method_name) || super
  end

  private

  def generate_derivated_methods(methods)
    derivated_methods = {}
    methods.keys.each do |method|
      derivated_methods[method.to_s.insert(-1, '?').to_sym] = false
      derivated_methods[method.to_s.insert(-1, '=').to_sym] = nil
    end
    derivated_methods
  end
end
