class Ticket

  def initialize(options)
    @customer_id = options['customer_id']
    @film_id = options['film_id']
    @id = options['id'].to_i() if options['id']
  end

  def save()
    sql = "INSERT INTO tickets (customer_id, film_id) VALUES($1, $2) RETURNING id;"
    values = [@customer_id, @film_id]
    pg_id_result = SqlRunner.run(sql, values)
    @id = pg_id_result[0]['id'].to_i()
  end
end
