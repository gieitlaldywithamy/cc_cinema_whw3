require_relative('models/customer.rb')
require_relative('models/film.rb')
require_relative('models/ticket.rb')

Customer.delete_all()
Film.delete_all()
Ticket.delete_all()

customer1 = Customer.new({'name' => 'Amy', 'funds' => 64.05})
customer2 = Customer.new({'name' => 'Mark', 'funds' => 164.05})
customer3 = Customer.new({'name' => 'Marky', 'funds' => 43.05})
customer1.save()
customer2.save()
customer3.save()
film1 = Film.new({'title' => 'Lion', 'price' => 10.50})
film2 = Film.new({'title' => 'Ex Machina', 'price' => 10.50})
film3 = Film.new({'title' => 'Filth', 'price' => 10.50})
film1.save()
film2.save()
film3.save()
ticket1 = Ticket.new({'customer_id' => customer1.id, 'film_id' => film1.id})
ticket2 = Ticket.new({'customer_id' => customer2.id, 'film_id' => film2.id})
ticket3 = Ticket.new({'customer_id' => customer3.id, 'film_id' => film3.id})
ticket1.save()
ticket2.save()
ticket3.save()

p Film.all()
p Customer.all()
p Ticket.all()

customer1_update = Customer.new({'name' => 'Alan', 'funds' => 10.05, 'id' => customer1.id});
customer1_update.update()

# ticket1.customer_id = customer2.id
# ticket1.update()

film3.name = 'Moon'
film3.update()

p "#{customer1_update.name} #{customer1_update.films()}"
p customer2.films()
p customer3.films()

p "audience #{film1} #{film1.audience()}"

customer1.buy_ticket(film2)

customer3.buy_ticket(film2)

p customer1.tickets_bought

p Film.screenings()
