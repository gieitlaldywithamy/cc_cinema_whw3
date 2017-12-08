class Film

  attr_reader :id, :price
  attr_accessor :name #this is solely for testing, remove

  def initialize(options)
    @title = options['title']
    @price = options['price']
    @start_time = options['start_time']
    @id = options['id'].to_i() if options['id']
  end

  def save()
    sql = "INSERT INTO films (title, price, start_time) VALUES ($1, $2, $3)
          RETURNING id;"
    values = [@title, @price, @start_time]
    pg_id_result = SqlRunner.run(sql, values)[0]
    @id = pg_id_result['id'].to_i()
  end

  def update()
    sql = "UPDATE films SET (title, price, start_time) = ($1, $2, $3) WHERE id = $4;"
    values = [@title, @price, @start_time, @id]
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

  def times()
    sql = "SELECT start_time FROM films WHERE films.title = $1"
    values = [@title]
    times = SqlRunner.run(sql, values)
    return times.values().reduce(:concat)
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
    return films.values.reduce(:concat)
  end

  def Film.times()
    sql = "SELECT start_time FROM films ORDER BY title;"
    films = SqlRunner.run(sql)
    return films.values.reduce(:concat)
  end

  def Film.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

end
