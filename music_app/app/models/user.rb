class User < ApplicationRecord
    validates :email, :session_token, presence: true, uniqueness: true
    validates :password_digest, presence: {message: "Password can't be blank"}
    #default message is "Password digest can't be blank.  Make custom message since user doesn't know what digest is"
    validates :password, length: {minimum: 6, allow_nil: true}
    #calls attr_reader below.  Need to allow nil true because password will never be set in the db.
    after_initialize :ensure_session_token
    #before_validation does something similar to after_initialize, don't need both
    
    attr_reader :password

    def self.generate_session_token
        SecureRandom::urlsafe_base64 #generates random string as session token
    end

    def self.find_by_credentials(email, password)
        user = User.find_by(email: email)
        return nil if user.nil? #user doesn't exist, return nil.  if user exists proceed to check password
        user.is_password?(password) ? user : nil #return user if password matches, else return nil
    end

    def reset_session_token!
        self.session_token = self.class.generate_session_token #generate token and assign to user calling above method
        self.save! #save user with new session token
        self.session_token #return session token now associated with this user
    end

    def ensure_session_token
        self.session_token ||= self.class.generate_session_token
        #if user alreasy has session token, keep it.  If not, generate a new one
        #use ||= so you don't have to make a trip to the db and set a new token every time
    end

    def password=(password)
        #.create creates a password_digest by hashing the passed in arg
        @password = password #sets password to an instance var we can validate at top.  Need this since the password is not saved as a db column.
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        #.new builds a password from the password_digest
        #then compares it with the passed in actual password
        BCrypt::Password.new(self.password_digest).is_password?(password)
    end
end

