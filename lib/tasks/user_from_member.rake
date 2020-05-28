namespace :user_from_member do
  task :add_users => :environment do
    ACTIVES = [
      "bgcall@indiana.edu",
      "twcall20117@yahoo.com",
      "whaste@umail.iu.edu",
      "Ahoney2011@yahoo.com",
      "ikarpov9@hotmail.com",
      "mccauley2525 @gmail.com",
      "Caleb.mcvicker@gmail.com",
      "Caroetken@gmail.com",
      "Brocksellers1@gmail.com",
      "ryan39935@yahoo.com",
      "Tylerjwaite21@gmail.com",
      "Derekyork56@gmail.com"
    ]

    Member.all.each do |member|
      if ACTIVES.include?(member.email)
        a = User.create(first_name: member.first_name, last_name: member.last_name, email: member.email, password: "Password1")
        member.user_id = a.id
        member.save
      end
    end
  end
end