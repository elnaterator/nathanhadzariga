# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


User.create(name: 'Nathan Hadzariga', email: 'n.hadzariga@gmail.com', password: 'password', password_confirmation: 'password', role: 'ADMIN')
User.create(name: 'Bill Billson', email: 'bill@gmail.com', password: 'password', password_confirmation: 'password', role: 'USER')


author = User.find_by(name: 'Nathan Hadzariga')
Post.create(author_id: author.id, title: 'Example admin post', body: 'Body of the example admin post.')

author = User.find_by(name: 'Bill Billson')
Post.create(author_id: author.id, title: 'Example user post', body: 'Body of the example user post.')


author = User.find_by(name: 'Nathan Hadzariga')
post = Post.find_by(title: 'Example admin post')
Comment.create(author_id: author.id, post_id: post.id, body: 'Example admin comment')

author = User.find_by(name: 'Bill Billson')
post = Post.find_by(title: 'Example admin post')
Comment.create(author_id: author.id, post_id: post.id, body: 'Example user comment')
