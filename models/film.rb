class Film

  def initialize(options)
    @title = options['title']
    @price = options['price']
    @id = options['id'].to_i() if options['id']
  end

  def save()
    sql = "INSERT INTO films
            (title, price) VALUES ($1, $2) RETURNING id;"
    values = [@title, @price]
    pg_id_result = SqlRunner.run(sql, values)
    @id = pg_id_result[0]['id'].to_i() #  do i need this?
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

  # def self.delete_all()
  #   sql = "DELETE FROM locations"
  #   SqlRunner.run(sql)
  # end
end
