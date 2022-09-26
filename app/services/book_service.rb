class BookService
  def self.search_by_location(location)
    response = conn.get("/search.json?title=#{location}")
    parse_response(response)
  end

  def self.parse_response(response)
    JSON.parse(response.body, symbolize_names: true) if response.status == 200
  end

  private
  def self.conn
    Faraday.new("http://openlibrary.org")
  end
end