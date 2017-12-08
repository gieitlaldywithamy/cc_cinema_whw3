require_relative('../db/sql_runner.rb')
require('pry-byebug')

class Customer

  def initialize(options)
    @name = options['name']
    @funds = options['funds']
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

  def Customer.all()
    sql = "SELECT * FROM customers;"
    customers_pg_format = SqlRunner.run(sql)
    return Customer.map_customers(customers_pg_format)
  end

  def Customer.map_customers(customer_hashes)
    return customer_hashes.map{|customer_hash| Customer.new(customer_hash)}
  end
end
