require_relative 'test_helper'

class EnvironmentTest < ActiveSupport::TestCase

  def setup
    create_and_activate_user
  end

  should 'return the default environment' do
    environment = Environment.default
    get "/api/v1/environment/default"
    json = JSON.parse(last_response.body)
    assert_equal environment.id, json['id']
  end

  should 'not return the default environment settings' do
    environment = Environment.default
    get "/api/v1/environment/default"
    json = JSON.parse(last_response.body)
    assert_equal environment.id, json['id']
    assert_nil json['settings']
  end

  should 'return the default environment settings for admin' do
    login_api
    environment = Environment.default
    environment.add_admin(person)
    get "/api/v1/environment/default?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equal environment.id, json['id']
    assert_equal environment.settings, json['settings']
  end

  should 'not return the default environment settings for non admin users' do
    login_api
    environment = Environment.default
    get "/api/v1/environment/default?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equal environment.id, json['id']
    assert_nil json['settings']
  end

  should 'return the default environment description' do
    environment = Environment.default
    get "/api/v1/environment/default"
    json = JSON.parse(last_response.body)
    assert_equal environment.description, json['description']
  end

  should 'return created environment' do
    environment = fast_create(Environment)
    default_env = Environment.default
    assert_not_equal environment.id, default_env.id
    get "/api/v1/environment/#{environment.id}"
    json = JSON.parse(last_response.body)
    assert_equal environment.id, json['id']
  end

  should 'return context environment' do
    context_env = fast_create(Environment)
    context_env.name = "example org"
    context_env.save
    context_env.domains<< Domain.new(:name => 'example.org')
    default_env = Environment.default
    assert_not_equal context_env.id, default_env.id
    get "/api/v1/environment/context"
    json = JSON.parse(last_response.body)
    assert_equal context_env.id, json['id']
  end

  should 'return no permissions for the current person that has no role in the environment' do
    login_api
    environment = Environment.default
    get "/api/v1/environment/default?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equal [], json['permissions']
  end

  should 'return permissions for the current person in the environment' do
    login_api
    environment = Environment.default
    environment.add_admin(person)
    get "/api/v1/environment/default?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equal environment.permissions_for(person), json['permissions']
  end

  should 'update environment' do
    login_api
    environment = Environment.default
    environment.add_admin(person)
    params[:environment] = {layout_template: "leftbar"}
    post "/api/v1/environment/#{environment.id}?#{params.to_query}"
    assert_equal "leftbar", environment.reload.layout_template
  end

  should 'forbid update for non admin users' do
    login_api
    environment = Environment.default
    params[:environment] = {layout_template: "leftbar"}
    post "/api/v1/environment/#{environment.id}?#{params.to_query}"
    assert_equal 403, last_response.status
    assert_equal "default", environment.reload.layout_template
  end

  should 'return signup fields' do
    environment = Environment.default
    environment.custom_person_fields = {
        "image" => {
        "active"=>"true",
        "required" =>"false",
        "signup"=>"true"
      }
    }
    environment.save

    get "/api/v1/environment/signup_person_fields"
    assert_equal 200, last_response.status
    json = JSON.parse(last_response.body)
    assert_equal ["image"].to_json, last_response.body
  end

  should 'return person fields for signup for multiple environments' do
    other_env = fast_create(Environment)
    other_env.custom_person_fields = {
        "image" => {
        "active"=>"true",
        "required" =>"false",
        "signup"=>"true"
      }
    }
    other_env.save
    default_env = Environment.default
    assert_not_equal other_env.id, default_env.id

    get "/api/v1/environment/signup_person_fields?id=#{other_env.id}"
    json = JSON.parse(last_response.body)
    assert_equal ["image"].to_json, last_response.body

    get "/api/v1/environment/signup_person_fields"
    json = JSON.parse(last_response.body)
    assert_equal [].to_json, last_response.body
  end
end
