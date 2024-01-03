# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# 189 is te limit of fake books' titles
30.times do
    Genre.create(name: Faker::Book.unique.genre)
end

262.times do
  Publisher.create(name: Faker::Book.unique.publisher)  
end

30.times do
  Author.create(name: Faker::Book.unique.author)  
end

189.times do
    Book.create(title: Faker::Book.unique.title, content: Faker::Lorem.unique.paragraphs,
    genre: Genre.find_by(name: Faker::Book.genre),
    publisher: Publisher.find_by(name: Faker::Book.publisher),
    author: Author.find(Faker::Number.between(from: 1, to: 30))) 
end

Book.reindex