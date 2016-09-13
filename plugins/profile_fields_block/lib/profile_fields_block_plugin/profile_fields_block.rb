class ProfileFieldsBlockPlugin::ProfileFieldsBlock < Block

  settings_items :fields, type: Hash, :default => {}
  settings_items :custom_fields, type: Hash, :default => {}
  settings_items :show_profile_image, type: :boolean, :default => false
  settings_items :show_profile_name, type: :boolean, :default => false

  attr_accessible :fields, :custom_fields, :show_profile_image, :show_profile_name

  before_save :clean_unchecked_fields
  before_save :symbolize_fields

  def self.description
    _('Choose public fields from a profile to be displayed in a block.')
  end

  def self.short_description
    _('Display profile public fields in a block.')
  end

  def self.pretty_name
     _('Profile Fields Block')
  end

  def help
     _('This blocks displays profile public fields.')
  end

  def api_content
    Grape::Presenters::Presenter.represent(fields_data).as_json
  end

  def available_fields
    return [] if self.owner.nil?
    self.owner.public_fields.sort
  end

  def available_custom_fields
    return [] if self.owner.nil?
    hash = {}
    self.owner.public_values.sort_by { |i| i.custom_field.name }.each do |value|
      hash[value.custom_field.name] = value.custom_field.format
    end
    hash
  end

  def show_field?(field)
    self.fields.has_key?(field) || self.custom_fields.has_key?(field)
  end

  def fields_data
    hash = {}
    hash.merge!(profile_fields_hash)
    hash.merge!(profile_custom_fields_hash)
    keys = hash.keys.sort
    hash.slice *keys
  end

  def cacheable?
    false
  end

  private

  def profile_fields_hash
    hash = {}
    profile = self.owner
    public_fields = profile.public_fields.map{ |f| f.to_sym }
    fields = self.fields.keys & public_fields
    fields.each do |field|
      hash[field] = { type: self.fields[field], content: profile.send(field) }
    end
    hash
  end

  def profile_custom_fields_hash
    hash = {}
    custom_values_hash = self.owner.custom_values_hash.slice *self.custom_fields.keys
    custom_values_hash.keys.each do |field|
      hash[field] = { type: custom_fields[field], content: custom_values_hash[field] }
    end
    hash
  end

  #when fields checkbox are unchecked, a hidden field with value =0 is given
  def clean_unchecked_fields
    self.fields.reject! { |field, type| type == "0" }
    self.custom_fields.reject! { |field, type| type == "0" }
  end

  def symbolize_fields
    self.fields.symbolize_keys!
    self.custom_fields.symbolize_keys!
  end
end

