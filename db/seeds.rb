# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

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

unless User.exists?(username: 'miggy_belly')
  User.create!(
    username: 'miggy_belly',
    email: 'miguel@churu.com',
    password: 'foobar',
    password_confirmation: 'foobar',
    jti: SecureRandom.uuid
  )
end

unless Puzzle.exists?(title: 'Multiples of 3 or 5')
  Puzzle.create(
    title: 'Multiples of 3 or 5',
    description: 'If we list all the natural numbers below 10 that are multiples of 3 or 5, we get 3, 5, 6, and 9. The sum of these multiples is 23. Find the sum of all the multiples of 3 or 5 below 1000.',
    creator_id: User.find_by(username: 'miggy_belly').id,
    expected_output: '233168'
  )
end

unless Puzzle.exists?(title: 'Even Fibonacci Numbers')
  Puzzle.create(
    title: 'Even Fibonacci Numbers',
    description: 'Each new term in the Fibonacci sequence is generated by adding the previous two terms. By considering the terms in the Fibonacci sequence whose values do not exceed four million, find the sum of the even-valued terms.',
    creator_id: User.find_by(username: 'miggy_belly').id,
    expected_output: '4613732'
  )
end

unless Puzzle.exists?(title: 'Largest Prime Factor')
  Puzzle.create(
    title: 'Largest Prime Factor',
    description: 'The prime factores of 13195 are 5, 7, 13, and 29. What is the largest prime factor of the number 600851475143?',
    creator_id: User.find_by(username: 'miggy_belly').id,
    expected_output: '6857'
  )
end
