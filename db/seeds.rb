# ユーザー
User.create!(name:  "範馬勇次郎",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             department: "管理者",
             admin:     true,
             basic_time: Time.zone.parse("7:30"),
             specified_working_time: Time.zone.parse("8:00")
             )
             
User.create!(name:  "花山薫",
             email: "example2@railstutorial.org",
             password:              "foobar2",
             password_confirmation: "foobar2",
             department: "管理者",
             admin:     false,
             basic_time: Time.parse("07:30"),
             specified_working_time: Time.parse("08:00")
             )

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               department: "sales",
               password:              password,
               password_confirmation: password,
               basic_time: Time.zone.parse("7:30"),
               specified_working_time: Time.zone.parse("8:00")
               )
end
