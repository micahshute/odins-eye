# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
password = "Password1!"

tag_types = ["Math", "Computer Science", "Programming", "Algorithms"]
reaction_types = ["like", "dislike", "genius", "report"]
tag_types.map!{ |tag| TagType.create(name: tag) }
reaction_types.map!{ |reaction| ReactionType.create(name: reaction)}
admin = User.create(name: "Admin", email: "admin@odinseye.com", password: "adminpassword123!@#", password_confirmation: "adminpassword123!@#")
micah = User.create(name: "Micah Shute", email: "test@test.com", password: password, password_confirmation: password)
taylor = User.create(name: "Taylor Swift", email:"taylor@swift.com", password: password, password_confirmation: password)
first_topic = Topic.create(user: micah, title: "What is the Fourier Transform?") 
first_reply = first_topic.posts.build(user: micah, content: "An equation mapping time domain to the frequency domain")
first_topic.tags << Tag.new(tag_type: TagType.find_by(name: "Math"), user: micah)
first_topic.save

classroom = Classroom.new(name: "Math Class", professor: micah)

classroom.save

class_topic = classroom.topics.build(user: micah, content: "Math stuff?")
class_topic.tags << Tag.new(tag_type: TagType.find_by(name: "Math"), user: micah)
classroom.save

classroom.students << taylor
classroom.tags << Tag.new(tag_type: TagType.find_by(name: "Math"), user: micah)
classroom.save
taylor.following << micah
micah.save

taylor.like(first_topic)
admin.like(first_reply)
taylor.dislike(first_reply)
taylor.message(micah, "I love you")
micah.message(taylor, "I know")
taylor.message(micah, "You stuck-up, half-witted, scruffy-looking nerf herder!")
micah.message(taylor, "Who's scruffy-lookin?")
admin.message(micah, "There's nothing to see. I used to live here, you know")
micah.message(admin, "You're going to die here, you know. Convenient.")
taylor.posts << Post.create(postable: first_reply, content: "This is not clever")
taylor.posts.last.posts << Post.create(user: micah, content: "whteva")
taylor.like(micah.posts.last)
micah.like(micah.posts.last)
admin.like(micah.posts.last)
micah.like(taylor.posts.last)
taylor.save

first_topic.tags << Tag.create(tag_type: tag_types[0], user: micah)

first_topic.save