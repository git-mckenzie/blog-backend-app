require "rails_helper"

RSpec.describe "Posts", type: :request do
  describe "GET /posts" do
    it "return all posts" do
      user = User.create!(name: "Zuck", email: "zuck@fb.com", password: "password")
      post = Post.create!(user_id: user.id, title: "rspec test", body: "does this work?", image: "img.png")
      post = Post.create!(user_id: user.id, title: "rspec asdfasfads", body: "does this work?", image: "img.png")

      get "/posts"
      posts = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(posts.length).to eq(2)
    end
  end

  describe "GET /posts/:id" do
    it "return a specific post" do
      user = User.create!(name: "Zuck", email: "zuck@fb.com", password: "password")
      post = Post.create!(user_id: user.id, title: "another rspec test", body: "does this work?", image: "img.png")

      post_id = Post.first.id
      get "/posts/#{post_id}"
      posts = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(posts["title"]).to eq("another rspec test")
    end
  end

  describe "POST /posts" do
    it "creates a post" do
      user = User.create!(name: "Zuck", email: "zuck@fb.com", password: "password")
      jwt = JWT.encode({ user_id: user.id },
                       Rails.application.credentials.fetch(:secret_key_base), "HS256")

      post "/posts", params: {
                       user_id: user.id,
                       title: "yet another rspec test",
                       body: "does this work?",
                       image: "img.png",
                     },
                     headers: { "Authorization" => "Bearer #{jwt}" }
      post = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(posts["title"]).to eq("yet another rspec test")
    end
  end
end
