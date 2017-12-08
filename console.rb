require_relative('models/customer.rb')
require_relative('models/film.rb')
require_relative('models/ticket.rb')

customer1 = Customer.new({'name' => 'Amy', 'funds' => 64.05})
customer1.save()
film1 = Film.new({'title' => 'Lion', 'price' => 10.50})
film1.save()
ticket1 = Ticket.new({'customer_id'=> 1, 'film_id' => 1})
ticket1.save()

p Film.all()
p Customer.all()
