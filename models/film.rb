class Film

  attr_reader :id, :price
  attr_accessor :name #this is solely for testing, remove

  def initialize(options)
    @title = options['title']
    @price = options['price']
    @id = options['id'].to_i() if options['id']
  end

  def save()
    sql = "INSERT INTO films (title, price) VALUES ($1, $2)
          RETURNING id;"
    values = [@title, @price]
    pg_id_result = SqlRunner.run(sql, values)[0]
    @id = pg_id_result['id'].to_i()
  end

  def update()
    sql = "UPDATE films SET (title, price) = ($1, $2) WHERE id = $3;"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def audience()
    sql = "
    SELECT customers.*
    FROM customers
    INNER JOIN tickets
    ON customers.id = tickets.customer_id
    WHERE $1 = tickets.film_id
    "
    values = [@id]
    audience = Customer.map_customers(SqlRunner.run(sql, values))
    return audience
  end

  def Film.map_pg_object(film_pg)
    return film_pg.map{|film_hash| Film.new(film_hash)}
  end

  def Film.all()
    sql = "SELECT * FROM films"
    film_hashes = SqlRunner.run(sql)
    films = Film.map_pg_object(film_hashes)
    return films
  end

  def Film.screenings()
    sql = "SELECT title FROM films"
    films = SqlRunner.run(sql)
    return films.values
  end

  def Film.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

end
