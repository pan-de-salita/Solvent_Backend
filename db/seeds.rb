# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Language.destroy_all

Judge0::Client.languages[:data]
              .sort_by { |language| language['id'] }
              .reverse
              .each do |language|
  language_details = language['name'].include?('(') ? language['name'].scan(/(.*?)\s+\((.*?)\)/).flatten : [language['name']]
  language_name = language_details[0]
  language_version = language_details[1]

  next unless Language.where(name: language_name).empty?

  Language.create!(id: language['id'], name: language_name, version: language_version)
end
