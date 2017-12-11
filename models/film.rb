require('pry-byebug')

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

  def num_screenings()
    sql = "SELECT COUNT(*) FROM screenings WHERE screenings.film_id = $1"
    values = [@id]
    screenings = SqlRunner.run(sql, values)
    return screenings[0]['count']
  end

  def busiest_time()
     sql = "SELECT screenings.start_time, COUNT(*)
             FROM screenings
             INNER JOIN tickets
             ON tickets.screening_id = screenings.id
           WHERE screenings.film_id = $1
          GROUP BY screenings.start_time

     "
     values = [@id]
     results = SqlRunner.run(sql, values)
     most_popular_result = results.max_by{|k,v| v}
     return most_popular_result['start_time']
   end
  # end



  def times()
    sql = "SELECT screenings.start_time
    FROM films
    INNER JOIN screenings
    ON films.id = screenings.film_id
    WHERE films.id= $1"
    values = [@id]
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

  def Film.get_name_by_id(id)
    sql = "SELECT title FROM films WHERE films.id=$1"
    pg_name = SqlRunner.run(sql, [id])
    begin
      return pg_name[0]['title']
    rescue IndexError
      return 'nil'
    end
  end

  # def Film.times()
  #   sql = "SELECT start_time FROM films ORDER BY title;"
  #   films = SqlRunner.run(sql)
  #   return films.values.reduce(:concat)
  # end

  def Film.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

end
