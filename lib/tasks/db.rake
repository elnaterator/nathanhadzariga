namespace :db do

  desc "Setup db from scratch and add sample data"
  task prep: [:drop, :create, :migrate, :seed, :sample_data] do
    puts "DB ready!!!"
  end

  desc "Populate db with sample data"
  task sample_data: :environment do
    User.create(name: "Nathan", email: "n.hadzariga@gmail.com", password: "password", password_confirmation: "password")
    User.create(name: "Constanza", email: "conicakz@gmail.com", password: "password", password_confirmation: "password")
    User.create(name: "Bill", email: "bill@bill.com", password: "password", password_confirmation: "password")
    User.create(name: "Fred", email: "fred@fred.com", password: "password", password_confirmation: "password")
  end

end
