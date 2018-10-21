# ユーザー
User.create!(name:  "柳川幸貴",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             department: "管理者",
             admin:     true,
             basic_time: Time.zone.parse("2018/04/07 7:30"),
             specified_working_time: Time.zone.parse("2018/04/07 8:00")
             )
             
User.create!(name:  "テスト一般ユーザ用",
             email: "example2@railstutorial.org",
             password:              "foobar2",
             password_confirmation: "foobar2",
             department: "管理者",
             admin:     false,
             basic_time: Time.parse("2018/04/07 07:30"),
             specified_working_time: Time.parse("2018/04/07 08:00")
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
               basic_time: Time.zone.parse("2018/04/07 8:00"),
               specified_working_time: Time.zone.parse("2018/04/07 7:00")
               )
end
