# ユーザー
User.create!(name:  "舘ひろし(admin)",
             email: "example111@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             department: "管理者",
             employee_number: 111,
             admin:     true,
             superior: false,
             basic_time: Time.zone.parse("7:30"),
             specified_working_time: Time.zone.parse("8:00")
             )
             
User.create!(name:  "野原ひろし(上長ユーザー)",
             email: "example222@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             department: "春日部防衛隊総統室長",
             employee_number: 222,
             admin:     false,
             superior: true,
             basic_time: Time.zone.parse("7:30"),
             specified_working_time: Time.zone.parse("8:00")
             )             
             
User.create!(name:  "猫ひろし(一般ユーザー)",
             email: "example333@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             department: "WAHAHA本舗",
             employee_number: 333,
             admin:     false,
             superior: false,
             basic_time: Time.zone.parse("7:30"),
             specified_working_time: Time.zone.parse("8:00")
             )


99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               employee_number: "#{n+1}.to_i",
               admin:     false,
               superior: false,
               basic_time: Time.zone.parse("7:30"),
               specified_working_time: Time.zone.parse("8:00")
             )
end
