# A logged-in device. The plain token is only available right after creation;
# the database keeps its SHA-256 digest, so a leaked table can't be replayed.
class Session < ApplicationRecord
  belongs_to :user

  attr_reader :token

  before_create :generate_token

  def self.find_by_token(token)
    find_by(token_digest: digest(token)) if token.present?
  end

  def self.digest(token)
    OpenSSL::Digest::SHA256.hexdigest(token)
  end

  # Avoids a write on every request.
  def touch_last_used
    update_column(:last_used_at, Time.current) if last_used_at.nil? || last_used_at.before?(1.hour.ago)
  end

  private
    def generate_token
      @token = SecureRandom.base58(32)
      self.token_digest = self.class.digest(@token)
    end
end
