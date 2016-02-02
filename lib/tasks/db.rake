namespace :db do

  desc "Setup db from scratch and add sample data"
  task prep: [:drop, :create, :migrate, :seed, :sample_data] do
    puts "DB ready!!!"
  end

  desc "Populate db with sample data"
  task sample_data: :environment do
    User.create(name: "Nathan", email: "n.hadzariga@gmail.com", password: "password", password_confirmation: "password", role: "ADMIN")
    User.create(name: "Constanza", email: "conicakz@gmail.com", password: "password", password_confirmation: "password", role: "ADMIN")
    User.create(name: "Bill", email: "bill@bill.com", password: "password", password_confirmation: "password")
    User.create(name: "Fred", email: "fred@fred.com", password: "password", password_confirmation: "password")

    Post.create(title: "Example post 1", body: "This is the body of example post 1.", author_id: 1)
    Post.create(title: "Example post 2", body: "This is the body of example post 2.", author_id: 1)
  end

end
