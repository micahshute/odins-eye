# Odin's Eye

A website designed with Ruby on Rails which facilitates a wide range of knowledge-sharing-based community activities. You can use the site to 
- ask and/or look up answers to specific questions
- blog about a topic you care about or just leared about
- contribute to the community by reacting to or posting back to others' questions or blogs
- creating a private or public classroom where you can post lectures or topics upon which you want the students to discuss.
- follow and message other users
- see statistics on your published topics, such as view count, reactions, most popular, etc.

### To visit the site, navigate to [https://odins-eye.herokuapp.com](https://odins-eye.herokuapp.com)

## To contribute

- Look at the `dev` branch to see which next steps have been taken which are not part of the site yet
- If you want to add something, clone the `dev` branch and `bundle install` to get it working. Submit a pull request when finished.
- The app uses `PostgreSQL` for development, testing, and production. You can find a detailed walkthough on how to set up PostgreSQL for WSL [here](https://odins-eye.herokuapp.com/topics/11) and the download page for mac is [here](https://www.postgresql.org/download/macosx/). There are multiple download options for Mac including Homebrew.


## Deployment

This app is crrently deployed on [Heroku](https://odins-eye.herokuapp.com)

## Tests

This project currently has no unit tests. Important tests to integrate would be: 

- Ensuring all posts, topics, reactions, and classrooms (owned) are deleted if a user is destroyed.
- Ensuring all reactions and replies are destroyed if a post or topic is destroyed
- Ensuring no unauthorized user can access unenrolled classrooms, or edit/delete/create posts not associatetd with their user.


## Built with

- Ruby on Rails
- `Kramdown` and `Rogue` for Markdown editing and syntax highlighting
- `Figaro` for Environment Variable Management
- `omniauth-google` for google login
   