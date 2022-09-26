class BooksSerializer
  include JSONAPI::Serializer

  set_id :id
  attributes :destination, :forecast, :total_books_found, :books
end