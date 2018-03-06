class User < ApplicationRecord
  has_secure_password

  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i.freeze
  PASSWORD_REGEX = /\A(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]{0,}).{8,}\z/.freeze

  has_one :token, inverse_of: :user, dependent: :destroy

  # validates :access_token, presence: true
  validates :email, presence: true, format: { with: EMAIL_REGEX }
  validates :password, format: { with: PASSWORD_REGEX }, if: -> { password.present? }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :height, numericality: { greater_than: 0 }, allow_nil: true
  validates :weight, numericality: { greater_than: 0 }, allow_nil: true

  def default_country
    'United States'
  end

  def name
    "#{first_name} #{last_name}"
  end

  def type
    'specializedUserWsDTO'
  end

  def as_json(options = default_json_options)
    super(options).deep_transform_keys! do |key|
      key = 'uid' if key.to_s == 'email'
      key.camelize(:lower)
    end
  end

  private

  def default_json_options
    {
      only: [
        :email,
        :first_name,
        :last_name,
        :city,
        :gender,
        :height,
        :weight,
      ],
      methods: [:default_country, :type, :name]
    }
  end
end
