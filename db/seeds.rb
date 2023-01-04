# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
if Doorkeeper::Application.count.zero?
  Doorkeeper::Application.create(name: 'API Client', redirect_uri: '', scopes: '')
end
User.find_or_create_by(email: 'admin@nimble.com') do |user|
  user.password = 'ilovenimble'
end
