class SocialProfile < ApplicationRecord
  belongs_to :user
  store      :others

  validates_uniqueness_of :uid, scope: :provider

  def self.find_for_oauth(auth)
    profile = find_or_create_by(uid: auth.uid, provider: auth.provider)
    profile.save_oauth_data!(auth)
    profile
  end

  def save_oauth_data!(auth)
    return unless valid_oauth?(auth)

    provider = auth["provider"]
    policy   = policy(provider, auth)

    self.update_attributes( uid:         policy.uid,
                            name:        policy.name,
                            nickname:    policy.nickname,
                            email:       policy.email,
                            url:         policy.url,
                            image_url:   policy.image_url,
                            description: policy.description,
                            credentials: policy.credentials,
                            raw_info:    policy.raw_info )
  end

  private

    def policy(provider, auth)
      class_name = "#{provider}".classify
      "OAuthPolicy::#{class_name}".constantize.new(auth)
    end

    def valid_oauth?(auth)
      (self.provider.to_s == auth['provider'].to_s) && (self.uid == auth['uid'])
    end
end
