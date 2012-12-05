# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
admins = User.create([{name: "Rainaldo Crosbourne", email: "rainaldo.crosbourne@time4lime.com"},
                      {name: "Dwayne Williams",     email: "dwayne.williams@time4lime.com"},
                      {name: "Bychan Brown",        email: "bychan.brown@time4lime.com"},
                      {name: "Sheldon Lucas",       email: "sheldon.lucas@time4lime.com"},
                      {name: "Nari Ramdon",         email: "nari.ramdon@time4lime.com"}])