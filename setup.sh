#!/bin/bash

# Navigate to the Rails blog application directory
cd "$(dirname "$0")"

# Creating the Rails application if it doesn't exist
if [ ! -d "rails-blog" ]; then
  rails new rails-blog --skip-bundle --skip-test --skip-system-test --skip-coffee --skip-javascript --skip-turbolinks --skip-spring
  cd rails-blog
else
  cd rails-blog
fi

# Bundling the dependencies
bundle install

# Setting up the database
rails db:create
rails db:migrate

# Generate a Blog model
rails generate model Blog title:string content:text
rails db:migrate

# Generate a Blogs controller
rails generate controller Blogs index show new create edit update destroy

# Create views for blogs
mkdir -p app/views/blogs
cat > app/views/blogs/index.html.erb <<EOL
<h1>Blogs</h1>
<%= link_to 'New Blog', new_blog_path %>
<ul>
  <% @blogs.each do |blog| %>
    <li><%= link_to blog.title, blog_path(blog) %></li>
  <% end %>
</ul>
EOL

cat > app/views/blogs/show.html.erb <<EOL
<h1><%= @blog.title %></h1>
<p><%= @blog.content %></p>
<%= link_to 'Edit', edit_blog_path(@blog) %>
<%= link_to 'Back', blogs_path %>
EOL

cat > app/views/blogs/new.html.erb <<EOL
<h1>New Blog</h1>
<%= form_with model: @blog do |form| %>
  <div>
    <%= form.label :title %>
    <%= form.text_field :title %>
  </div>
  <div>
    <%= form.label :content %>
    <%= form.text_area :content %>
  </div>
  <div>
    <%= form.submit %>
  </div>
<% end %>
<%= link_to 'Back', blogs_path %>
EOL

cat > app/views/blogs/edit.html.erb <<EOL
<h1>Edit Blog</h1>
<%= form_with model: @blog do |form| %>
  <div>
    <%= form.label :title %>
    <%= form.text_field :title %>
  </div>
  <div>
    <%= form.label :content %>
    <%= form.text_area :content %>
  </div>
  <div>
    <%= form.submit %>
  </div>
<% end %>
<%= link_to 'Back', blogs_path %>
EOL

# Adding routes for blogs
cat >> config/routes.rb <<EOL
Rails.application.routes.draw do
  resources :blogs
end
EOL

echo "Setup complete. Run 'rails server' to start your Rails blog application."