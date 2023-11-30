class User < ActiveRecord::Base
  has_secure_password
  before_create :generate_otp_secret_key

  attr_accessor :confirmation_token
  
  validates :otp_secret_key, presence: true, if: :two_fa_enabled?
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:password] }

  def generate_otp_secret_key
    self.confirmation_token = SecureRandom.urlsafe_base64
  end

  def enable_two_factor_authentication
    generate_otp_secret_key
    update(two_fa_enabled: true)
  end

  def send_otp
    client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])

    otp = generate_otp
    message = "Your OTP: #{otp}"

    client.messages.create(
      from: 'your_twilio_phone_number',
      to: phone_number,
      body: message
    )

    puts "Your OTP: #{generate_otp}"
  end

  def verify_otp(otp)
    ROTP::TOTP.new(otp_secret_key).verify(otp)
  end

  private

  def generate_otp
    ROTP::TOTP.new(otp_secret_key).now
  end
end
