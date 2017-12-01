FactoryGirl.define do
  factory :authorizations do
    user
    provider 'google_oauth2'
  end
end
