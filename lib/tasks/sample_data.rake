namespace :db do
  desc 'Fill database with sample data'
  task populate: :environment do
    User.create!(name: 'Example User',
                 email: 'example@railstutorial.jp',
                 password: 'foobar',
                 password_confirmation: 'foobar',
                 admin: true)
    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@railstutorial.jp"
      password = 'password'
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end

    users = User.all(limit: 2)
    50.times do |n|
      title = "Work Title #{n}"
      other = Faker::Lorem.sentence(5)
      users.each do |user|
        work = user.works.create!(title: title,
                                  payment: 100.0,
                                  other: other,
                                  user: user,
                                  orderer_id: 0)
        5.times do |n2|
          work.worktimes.create!(start_time: n2.minute.ago,
                                 end_time: (n2+1).minute.ago,
                                 work: work)
        end
      end
    end
    5.times do |n|
      name = "Orderer Name #{n}"
      users.each { |user| user.orderers.create!(name: name, user: user) }
    end
  end
end
