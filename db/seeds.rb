if User.all.any?
  User.destroy_all
end

User.create!([
  {
    username: "J3RN",
    email: "jonarnett90@gmail.com",
    access_token: ENV["DO_TOKEN"],
    password: "blargblarg"
  },
  {
    username: "TestUser",
    email: "test@example.com",
    password: "testtest"
  },
  {
    username: "TestTest",
    email: "test@example.org",
    password: "testtest"
  },
])
