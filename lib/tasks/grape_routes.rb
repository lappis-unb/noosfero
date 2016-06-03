desc "Print out grape routes"
task :grape_routes => :environment do
  #require 'api/api.rb'
  Api::App.routes.each do |route|
    puts route
    method = route.route_method
    path = route.route_path
    puts "     #{method} #{path}"
  end
end
