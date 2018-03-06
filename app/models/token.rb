class Token < ApplicationRecord
  after_initialize :generate_access_token, if: :new_record?

  belongs_to :user, inverse_of: :token, optional: true

  def expires_in
    1.day.to_i
  end

  def as_json(options = default_json_options)
    super(options).deep_transform_keys! do |key|
      key = 'scope' if key.to_s == 'access_token_scope'
      key = 'token_type' if key.to_s == 'access_token_type'
      key
    end
  end

  private

  def generate_access_token
    return if persisted?

    self.access_token = SecureRandom.urlsafe_base64
    self.access_token_created_at = Time.zone.now
  end

  def default_json_options
    {
      only: [:access_token, :access_token_type, :access_token_scope],
      methods: [:expires_in]
    }
  end
end
