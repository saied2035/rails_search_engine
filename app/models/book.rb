class Book < ApplicationRecord
    belongs_to :genre
    belongs_to :author
    belongs_to :publisher

    searchkick text_middle: [:title, :content, :author_name, :genre_name, :publisher_name]

    def search_data
        attributes.merge(
            genre_name: genre.name,
            author_name: author.name,
            publisher_name: publisher.name
    )
    end
end
