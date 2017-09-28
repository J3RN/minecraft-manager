if User.all.any?
  User.destroy_all
end

User.create!([
  {
    username: "Test User",
    email: "test@example.com",
    password: "testtest"
  },
  {
    username: "A Second Test User",
    email: "test@example.org",
    password: "testtest"
  },
])
