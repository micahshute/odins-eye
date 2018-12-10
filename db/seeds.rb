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
first_topic = Topic.create(user: micah, title: "What is the Fourier Transform?", content: "No, I really don't know. Can anyone tell me?") 
first_reply = first_topic.posts.build(user: micah, content: "An equation mapping time domain to the frequency domain")
first_topic.tags << Tag.new(tag_type: TagType.find_by(name: "Math"), user: micah)
first_topic.save

cs_topic = Topic.create(user: micah, title: "Sorting algorithms", content: "Here's what you have to know about sorting algorithms. First of all, everyone talks about them but nobody uses them. Also, ")
cs_topic.tag("Computer Science", "Programming", "Beginners")
cs_topic.save
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


blog_post = Topic.new(user: taylor, title: "How to program a queue", content:
'# Programming a Queue.
--------------------
A queue is a limited version of an array. It is useful because it provides a simple abstraction for systems which require its specific functionality.

As a wise man once said:

> Queues are cool.

Things that use a queue:

* Searching through a trie (breadth-first-search)
* First-in-line applications

### So, how do you make a queue? 

(Btw, $E=mc^2$)

__You need 2 methods:__ `pop` and `push`. `pop` will remove the 0th element in the array and return it, and `push` will add an item to the end of the array.


~~~ ruby
def what?
  42
end
~~~

~~~ruby 
class Queue

    attr_reader :data

    def initialize(arr)
        @data = arr
    end

    def pop
        r_val = @data[0]
        @data = @data.slice(1, @data.length - 1)
        return r_val
    end

    def push(val)
        @data[@data.length] = val
    end

end
~~~


~~~
    Also, you can put stuff in here that isn\'t a language
~~~

1. list 1 item 1
    1. nested list item 1
    2. nested list item 2
10. list 1 item 2
    1. nested list item 1


| Header1 | Header2 | Header3 |
|:--------|:-------:|--------:|
| cell1   | cell2   | cell3   |
| cell4   | cell5   | cell6   |
|----
| cell1   | cell2   | cell3   |
| cell4   | cell5   | cell6   |
|=====
| Foot1   | Foot2   | Foot3
{: rules="groups"}

This is *emphasized*, _this_ too!

A [link](http://kramdown.gettalong.org)
to the kramdown homepage.

This is a text with a
footnote[^2].

[^2]:
    And here is the definition.

    > With a quote!



This is *red*{: style="color: red"}.
'
)

blog_post.save