module Follower
  extend ActiveSupport::Concern

  included do
    has_many :owned_circles, as: :owner, :class_name => "Circle"
  end

  def follow(profile, circles)
    circles = [circles] unless circles.is_a?(Array)
    circles.each do |new_circle|
      next if new_circle.owner != self || !profile.kind_of?(new_circle.profile_type.constantize)
      ProfileFollower.create(profile: profile, circle: new_circle)
    end
  end

  def follows?(profile)
    return false if profile.nil?
    profile.followed_by?(self)
  end

  def unfollow(profile)
    ProfileFollower.with_follower(self).with_profile(profile).destroy_all
  end

  def local_followed_profiles
    Profile.joins(:circles).where("circles.owner_id = ?", self.id).uniq
  end

  def external_followed_profiles
    ExternalProfile.joins(:circles).where("circles.owner_id = ?", self.id).uniq
  end

  def followed_profiles
    local_followed_profiles + external_followed_profiles
  end

  def update_profile_circles(profile, new_circles)
    profile_circles = ProfileFollower.with_profile(profile).with_follower(self).map(&:circle)
    circles_to_add = new_circles - profile_circles
    self.follow(profile, circles_to_add)

    circles_to_remove = profile_circles - new_circles
    ProfileFollower.where('circle_id IN (?) AND profile_id = ?',
                          circles_to_remove.map(&:id), profile.id).destroy_all
  end

  def remove_profile_from_circle(profile, circle)
    return if circle.owner != self
    ProfileFollower.with_profile(profile).with_circle(circle).destroy_all
  end

end
