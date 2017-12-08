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


  def Ticket.all()
    sql = "SELECT * FROM tickets;"
    tickets_pg = SqlRunner.run(sql)
    return Ticket.map_pg_ticket(tickets_pg)
  end

  def Ticket.map_pg_ticket(tickets_pg)
    return tickets_pg.map{|ticket| Ticket.new(ticket)}
  end
end
