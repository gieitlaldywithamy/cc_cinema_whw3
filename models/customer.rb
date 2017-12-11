require_relative('../db/sql_runner.rb')
require_relative('film.rb')
require('pry-byebug')

class Customer

  attr_reader :id, :name, :funds


  def initialize(options)
    @name = options['name']
    @funds = options['funds'].to_f()
    @id = options['id'].to_i if options['id']
  end

  def save()
    sql = "INSERT INTO customers (name, funds)
     VALUES ($1, $2)
      RETURNING id;"
    values = [@name, @funds]
    id_result = SqlRunner.run(sql, [@name, @funds])[0]
    @id = id_result['id']
    # binding.pry
  end

  def update()
    sql = "UPDATE customers SET
      name = $1,
      funds = $2
      WHERE id = $3;"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def films
    sql = "SELECT DISTINCT title FROM films
          INNER JOIN screenings ON screenings.film_id = films.id
          INNER JOIN tickets ON screenings.id = tickets.screening_id
          WHERE tickets.customer_id = $1;
          "
    films_pg =  SqlRunner.run(sql, [@id])
    return Film.map_pg_object(films_pg)
  end

  def pay(cost)
    @funds -= cost if @funds > cost
  end

  #   wouldnt buy a ticket for a film since changing structure
  # def buy_ticket(film)

  #   pay(film.price)
  #   new_ticket_issue = Ticket.new({'customer_id' => @id, 'film_id' => film.id })
  #   new_ticket_issue.save()
  #   self.update()
  # end

  def buy_ticket(screening)
    sql = "SELECT films.price
          FROM films
          INNER JOIN screenings ON films.id = screenings.film_id"
    price = SqlRunner.run(sql)[0]['price']
    pay(price)
    new_ticket_issue = Ticket.new({'customer_id' => @id, 'screening_id' => screening.id })
    new_ticket_issue.save()
    nil

  end

  def tickets_bought()
    sql = "SELECT *
      FROM tickets
      WHERE tickets.customer_id = $1"
    tickets_bought = SqlRunner.run(sql, [@id])
    return tickets_bought.cmd_tuples
  end

  def Customer.all()
    sql = "SELECT * FROM customers;"
    customers_pg_format = SqlRunner.run(sql)
    return Customer.map_customers(customers_pg_format)
  end

  def Customer.map_customers(customer_hashes)
    return customer_hashes.map{|customer_hash| Customer.new(customer_hash)}
  end

  def Customer.delete_all()
    sql = "DELETE FROM customers;"
    SqlRunner.run(sql)
  end


end
