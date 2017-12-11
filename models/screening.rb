class Screening

  attr_reader :id

  def initialize(options)
    @film_id = options['film_id']
    @start_time = options['start_time']
    @id = options['id'].to_i if options['id']
  end

  def save()
    if(@id)
      update()
    else
      insert()
    end
  end

  def insert()
    sql = "INSERT INTO screenings (film_id, start_time) VALUES ($1, $2) RETURNING id"
    pg_id = SqlRunner.run(sql, [@film_id, @start_time])
    @id = pg_id[0]['id']
  end

  def update()
    sql = "UPDATE screenings SET film_id=$1, start_time=$2 WHERE id=$3"
    values = [@film_id, @start_time, @id]
    SqlRunner.run(sql, values)
    # do i want to return anything?
  end

  def audience()
    sql = "
    SELECT customers.*
    FROM customers
    INNER JOIN tickets
    ON customers.id = tickets.customer_id
    WHERE $1 = tickets.screening_id
    "
    values = [@id]
    audience = Customer.map_customers(SqlRunner.run(sql, values))
    return audience
  end

  def Screening.all()
    sql = "SELECT * FROM screenings"
    screening_hash = SqlRunner.run(sql)
    return Screening.map(screening_hash)
  end

  def Screening.map(screening_pg)
    return screening_pg.map{|screening_hash| Screening.new(screening_hash)}
  end
end
