require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'

TOKEN_STORE = ActiveSupport::Cache::MemoryStore.new

GOOGLE_CLIENT_ID = Google::Auth::ClientId.new(
  Rails.application.secrets.google_api_client_id,
  Rails.application.secrets.google_api_client_secret
)
