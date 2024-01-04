class SearchController < ApplicationController
  def index 
    @recomendations = current_user.recomendation.nil? ? [] :
    Book.where(
      "#{current_user.recomendation_type}": 
      current_user.recomendation_type.classify.constantize.find_by(name: current_user.recomendation)
    )
  end

  def search
    @books = Book.search(params[:search], operator: 'or')
    @recomendations = @books.length > 0 ? analytics : []
    puts "recomendations: #{@recomendations[0]}"
    render turbo_stream: [
      turbo_stream.update('books', partial: 'results', locals: {books: @books }),
      turbo_stream.update('recomendations', partial: 'recomendations',
      locals: {recomendations: @recomendations })
    ] 
  end
  
  def analytics
    genres = {}
    max_genre = []
    publishers = {}
    max_publisher =  []
    authors = {}
    max_author = []
    
    @books.includes(:genre, :publisher, :author).each do |book|

      genres["#{book.genre.name}"] = genres["#{book.genre.name}"].nil? ? 
      { ids: [book.id], repeat: 1 } 
      :
      { ids: genres["#{book.genre.name}"][:ids].push(book.id) , 
      repeat: genres["#{book.genre.name}"][:repeat] + 1 }

      max_genre[genres["#{book.genre.name}"][:repeat]] = book.genre

      publishers["#{book.publisher.name}"] = publishers["#{book.publisher.name}"].nil? ? 
      { ids: [book.id], repeat: 1 } 
      :
      { ids: publishers["#{book.publisher.name}"][:ids].push(book.id) ,
      repeat: publishers["#{book.publisher.name}"][:repeat] + 1 }

      max_publisher[publishers["#{book.publisher.name}"][:repeat]] = book.publisher

      authors["#{book.author.name}"] = authors["#{book.author.name}"].nil? ? 
      { ids: [book.id], repeat: 1 } 
      :
      { ids: authors["#{book.author.name}"][:ids].push(book.id) ,
      repeat: authors["#{book.author.name}"][:repeat] + 1 }

      max_author[authors["#{book.author.name}"][:repeat]] = book.author
    end

    author = max_author[max_author.length - 1]
    genre = max_genre[max_genre.length - 1]
    publisher = max_publisher[max_publisher.length - 1]

    author_books = Book.where(author: author).
    where.not(id: authors["#{author.name}"][:ids])

    genre_books = Book.where(genre: genre).
    where.not(id: genres["#{genre.name}"][:ids])

    publisher_books = Book.where(publisher: publisher).
    where.not(id: publishers["#{publisher.name}"][:ids])

    max_arr = [author_books.length, genre_books.length, publisher_books.length]
    max_index = max_arr.index(max_arr.max)
    if max_index == 0
      current_user.update_columns(recomendation: author.name, recomendation_type: 'author')
    elsif max_index == 1
      current_user.update_columns(recomendation: genre.name, recomendation_type: 'genre')
    else
      current_user.update_columns(recomendation: publisher.name, recomendation_type: 'publisher')   
    end  
    return max_index == 0 ? author_books : max_arr == 1 ? genre_books : publisher_books
  end  
end
