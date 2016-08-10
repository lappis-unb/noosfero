# A pseudo profile is a person from a remote network
class ExternalPerson < ExternalProfile

  include Human
  include ProfileEntity
  include Follower

  validates_uniqueness_of :identifier, scope: :source
  validates_presence_of :source, :email, :created_at

  attr_accessible :source, :email, :created_at

  def self.get_or_create(webfinger)
    user = ExternalPerson.find_by(identifier: webfinger.identifier, source: webfinger.domain)
    if user.nil?
      user = ExternalPerson.create!(identifier: webfinger.identifier,
                                    name: webfinger.name,
                                    source: webfinger.domain,
                                    email: webfinger.email,
                                    created_at: webfinger.created_at
                                   )
    end
    user
  end

  def privacy_setting
    _('Public profile')
  end


  alias :public_profile_url :url

  def admin_url
    "http://#{self.source}/myprofile/#{self.identifier}"
  end

  def wall_url
    self.url
  end
  def tasks_url
    self.url
  end
  def leave_url(reload = false)
    self.url
  end
  def join_url
    self.url
  end
  def join_not_logged_url
    self.url
  end
  def check_membership_url
    self.url
  end
  def add_url
    self.url
  end
  def check_friendship_url
    self.url
  end
  def people_suggestions_url
    self.url
  end
  def communities_suggestions_url
    self.url
  end
  def top_url(scheme = 'http')
    "#{scheme}://#{self.source}"
  end

  def preferred_login_redirection
    environment.redirection_after_login
  end

  def location
    self.source
  end

  def default_hostname
    environment.default_hostname
  end

  def possible_domains
    environment.domains
  end

  def person?
    true
  end

  def contact_email(*args)
    self.email
  end

  def notification_emails
    [self.contact_email]
  end

  def email_domain
    self.source
  end

  def email_addresses
    ['%s@%s' % [self.identifier, self.source] ]
  end

  def jid(options = {})
    "#{self.identifier}@#{self.source}"
  end
  def full_jid(options = {})
    "#{jid(options)}/#{self.name}"
  end

  def data_hash(gravatar_default = nil)
    friends_list = {}
    {
      'login' => self.identifier,
      'name' => self.name,
      'email' => self.email,
      'avatar' => self.profile_custom_icon(gravatar_default),
      'is_admin' => self.is_admin?,
      'since_month' => self.created_at.month,
      'since_year' => self.created_at.year,
      'email_domain' => self.source,
      'friends_list' => friends_list,
      'enterprises' => [],
      'amount_of_friends' => friends_list.count,
      'chat_enabled' => false
    }
  end

  # External Person should respond to all methods in Person and Profile
  def person_instance_methods
    methods_and_responses = {
     enterprises: Enterprise.none, communities: Community.none, friends:
     Person.none, memberships: Profile.none, friendships: Person.none,
     following_articles: Article.none, article_followers: ArticleFollower.none,
     requested_tasks: Task.none, mailings: Mailing.none, scraps_sent:
     Scrap.none, favorite_enterprise_people: FavoriteEnterprisePerson.none,
     favorite_enterprises: Enterprise.none, acepted_forums: Forum.none,
     articles_with_access: Article.none, suggested_profiles:
     ProfileSuggestion.none, suggested_people: ProfileSuggestion.none,
     suggested_communities: ProfileSuggestion.none, user: nil,
     refused_communities: Community.none, has_permission?: false,
     has_permission_with_admin?: false, has_permission_without_admin?: false,
     has_permission_with_plugins?: false, has_permission_without_plugins?:
     false, memberships_by_role: Person.none, can_change_homepage?: false,
     can_control_scrap?: false, receives_scrap_notification?: false,
     can_control_activity?: false, can_post_content?: false,
     suggested_friend_groups: [], friend_groups: [], add_friend: nil,
     already_request_friendship?: false, remove_friend: nil,
     presence_of_required_fields: nil, active_fields: [], required_fields: [],
     signup_fields: [], default_set_of_blocks: [], default_set_of_boxes: [],
     default_set_of_articles: [], cell_phone: nil, comercial_phone: nil,
     nationality: nil, schooling: nil, contact_information: nil, sex: nil,
     birth_date: nil, jabber_id: nil, personal_website: nil, address_reference:
     nil, district: nil, schooling_status: nil, formation: nil,
     custom_formation: nil, area_of_study: nil, custom_area_of_study: nil,
     professional_activity: nil, organization_website: nil, organization: nil,
     photo: nil, city: nil, state: nil, country: nil, zip_code: nil,
     address_line2: nil, copy_communities_from: nil,
     has_organization_pending_tasks?: false, organizations_with_pending_tasks:
     Organization.none, pending_tasks_for_organization: Task.none,
     build_contact: nil, is_a_friend?: false, ask_to_join?: false, refuse_join:
     nil, blocks_to_expire_cache: [], cache_keys: [], communities_cache_key: '',
     friends_cache_key: '', manage_friends_cache_key: '',
     relationships_cache_key: '', is_member_of?: false,
     each_friend: nil, is_last_admin?: false, is_last_admin_leaving?: false,
     leave: nil, last_notification: nil, notification_time: 0, notifier: nil,
     remove_suggestion: nil, allow_invitation_from?: false, in_social_circle?: false,
     allow_followers: false
    }

    derivated_methods = generate_derivated_methods(methods_and_responses)
    derivated_methods.merge(methods_and_responses)
  end

  def method_missing(method, *args, &block)
    if person_instance_methods.keys.include?(method)
      return person_instance_methods[method]
    end
    super(method, *args, &block)
  end

  def respond_to_missing?(method_name, include_private = false)
    person_instance_methods.keys.include?(method_name) ||
    super
  end

  def kind_of?(klass)
    (klass == Person) ? true : super
  end
end
