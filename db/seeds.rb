# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'

number_of_tasks = 100000

tasks = []



number_of_tasks.times do |i|
  tasks << Task.new(
    name: Faker::Book.title,
    description: Faker::Lorem.paragraph,
    position: i + 30000,
  )
end

Task.import(tasks)

puts "#{number_of_tasks} tasks have been generated."