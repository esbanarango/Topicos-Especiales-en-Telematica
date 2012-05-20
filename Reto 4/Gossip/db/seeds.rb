# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


User.create!(username: "admin", password: "adminadmin", password_confirmation: "adminadmin", admin:true)


Room.create!(name: "General", description: "Chat about the latest news, interesting gossip. Comment about the press, trivia, news, sports and technology.")
Room.create!(name: "Arts & Entertainment", description: "Chat with amazing people about culture, painting, modern art, graphic arts and art cinema.")
Room.create!(name: "Sports", description: "Chat about the latest news about the sports around the world. What have Messi said so far?.")
Room.create!(name: "Health & Beauty", description: "Chat about beauty, makeup, hairdressing, massage, diet, cosmetics and beauty tips. Share with beautiful women on nutrition, health, diet, health, welfare and healthy living.")
Room.create!(name: "Erotic Zone", description: "Erotic Zone is the ideal place for secret meetings. Meet people looking for erotic games. Make interesting contacts. Looking for boys and girls who want to chat about hot topics, sex games and erotic stories. Meet hot girls and boys.")