module Api
  module V1
    class Environments < Grape::API

      [ 'environment', 'environments' ].each do |path|
        resource "#{path}" do
          helpers do
            def target_env(params)
              local_environment = nil

              if (params[:id] == "default")
                local_environment = Environment.default
              elsif (params[:id] == "context")
                local_environment = environment
              else
                local_environment = Environment.find_by(id: params[:id])
                local_environment ||= Environment.default
              end

              local_environment
            end
          end

          desc "Return the person information"
          get '/signup_person_fields' do
            status Api::Status::DEPRECATED if path == 'environment'
            environment = target_env(params)
            present environment.signup_person_fields
          end

          get ':id' do
            status Api::Status::DEPRECATED if path == 'environment'
            environment = target_env(params)
            present_partial environment, with: Entities::Environment, is_admin: is_admin?(environment), current_person: current_person
          end

          desc "Update environment information"
          post ':id' do
            authenticate!
            environment = target_env(params)
            return forbidden! unless is_admin?(environment)
            environment.update_attributes!(params[:environment])
            status Api::Status::DEPRECATED if path == 'environment'
            present_partial environment, with: Entities::Environment, is_admin: is_admin?(environment), current_person: current_person
          end

        end
      end
    end
  end
end
