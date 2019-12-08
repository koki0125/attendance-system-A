# ユーザー
User.create!(name:  "舘ひろし(admin)",
             email: "admin@railstutorial.org",
             password:              "password",
             password_confirmation: "password",
             department: "管理者",
             employee_number: 111,
             admin:     true,
             superior: false,
             designated_start_time: Time.zone.parse("10:00"),
             designated_finish_time: Time.zone.parse("18:00"),
             uid: 111,
             basic_time: Time.zone.parse("7:30"),
            # specified_working_time: Time.zone.parse("8:00")
             )
             
User.create!(name:  "野原ひろし(上長ユーザー)",
             email: "superior1@railstutorial.org",
             password:              "password",
             password_confirmation: "password",
             department: "春日部防衛隊総統室長",
             employee_number: 222,
             admin:     false,
             superior:  true,
             designated_start_time: Time.zone.parse("10:00"),
             designated_finish_time: Time.zone.parse("18:00"),
             uid: 222,
             basic_time: Time.zone.parse("7:30"),
            # specified_working_time: Time.zone.parse("8:00")
             )    

User.create!(name:  "五木ひろし(上長ユーザー)",
             email: "superior2@railstutorial.org",
             password:              "password",
             password_confirmation: "password",
             department: "五木プロモーション",
             employee_number: 333,
             admin:     false,
             superior:  true,
             designated_start_time: Time.zone.parse("15:00"),
             designated_finish_time: Time.zone.parse("23:00"),
             uid: 333,
             basic_time: Time.zone.parse("7:30"),
            # specified_working_time: Time.zone.parse("8:00")
             ) 
             
User.create!(name:  "猫ひろし(一般ユーザー)",
             email: "employee@railstutorial.org",
             password:              "password",
             password_confirmation: "password",
             department: "WAHAHA本舗",
             employee_number: 444,
             admin:     false,
             superior:  false,
             designated_start_time: Time.zone.parse("10:00"),
             designated_finish_time: Time.zone.parse("18:00"),
             uid: 444,
             basic_time: Time.zone.parse("7:30"),
            # specified_working_time: Time.zone.parse("8:00")
             )
             
User.create!(name:  "ヒロシ(一般ユーザー)",
             email: "employee2@railstutorial.org",
             password:              "password",
             password_confirmation: "password",
             department: "福岡吉本",
             employee_number: 555,
             admin:     false,
             superior:  false,
             designated_start_time: Time.zone.parse("10:00"),
             designated_finish_time: Time.zone.parse("18:00"),
             uid: 555,
             basic_time: Time.zone.parse("7:30"),
            # specified_working_time: Time.zone.parse("8:00")
             )

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               department: "WAHAHA本舗",
               employee_number: "#{n+1}.to_i",
               admin:     false,
               superior:  false,
               designated_start_time: Time.zone.parse("10:00"),
               designated_finish_time: Time.zone.parse("18:00"),
               uid: "#{n+1}.to_s",
               basic_time: Time.zone.parse("7:30"),
              # specified_working_time: Time.zone.parse("8:00")
             )

end