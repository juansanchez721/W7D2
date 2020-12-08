class User < ApplicationRecord

    validates :email, :password_digest, :session_token, presence: true
    validates :email, :session_token, uniqueness: true #<- editing user, not attribute we save to DB
    validates :password, length: {minimum: 2}, allow_nil: true
    after_initialize :ensure_session_token

    attr_reader :password #so we can validates the password above


    def self.generate_session_token

        SecureRandom::urlsafe_base64(16)

    end
    
    def reset_session_token!

        self.update!(session_token: self.class.generate_session_token) #update! the session_token and save in the DB
        self.session_token #return the session_token
    end

    def self.find_by_credentials(email, password)

        user = User.find_by(email: email) #finds uder by email. if no email, user = nil
        return nil unless user && user.is_password?(password) #if there is a user, check to see if their password matched the password they gave us
        user

    end

    



    def password=(password)

        @password = password #sets @password to store password that user passes in
        self.password_digest = BCrypt::Password.create(password) #sets password_digest attribute and saves in DB

    end

    def is_password?(password)

        bcrypt_password = BCrypt::Password.new(self.password_digest) #instantiates new bcrypt password object with DB password_digest 
        bcrypt_password.is_password?(password) #bcrypt hashes/salts plain text input password to see if it matches password_digest

    end

    private

    
    def ensure_session_token #ensures session token if none exists

        self.session_token ||= self.class.generate_session_token

    end


end

### gem 'bcrypt', '~> 3.1.2' needed for Bcrypt
