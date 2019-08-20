# table to class mapping
class User < ActiveRecord::Base
    has_secure_password
    has_many :comments #adds methods to user
    #this will add some new methods for users for you
    #adds .password method you can pass in the original
    # .password will pass to bcrypt to digest it

end


# u = User.new
# u.email = 'esdf@gmail.com'
# u.password = 'pudding'

# pushes password as a secure password


# Authenticate('pudding') will return object if password