class User
  module HasGoogleCalendar
    extend ActiveSupport::Concern

    GOOGLE_CALENDAR_READ_ONLY_SCOPE = ::Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY
    GOOGLE_CALENDAR_OOB_URI = 'http://localhost:3000/authorizations'.freeze

    def has_google_calendar?
      google_calendar_authorization.present?
    end

    def google_calendar_authorization
      authorizations.where("'#{GOOGLE_CALENDAR_READ_ONLY_SCOPE}' = ANY (scopes)")&.first
    end

    def get_gcal_credentials
      authorizer = Google::Auth::UserAuthorizer.new(
        ::GOOGLE_CLIENT_ID,
        GOOGLE_CALENDAR_READ_ONLY_SCOPE,
        GcalendarTokenStore.new
      )
      credentials = authorizer.get_credentials(uid)
      raise 'User must authorize google calendar integration' unless credentials.present?
      credentials
    end

    def get_and_store_gcal_credentials_from_code(code)
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: uid,
        code: code,
        base_url: GOOGLE_CALENDAR_OOB_URI,
        scope: GOOGLE_CALENDAR_READ_ONLY_SCOPE
      )
    end

    def get_gcal_events
      service = Google::Apis::CalendarV3::CalendarService.new
      service.client_options.application_name = 'Flow'
      credentials = get_gcal_credentials

      service.authorization = credentials

      # Fetch the next 10 events for the user
      calendar_id = 'primary'
      response = service.list_events(calendar_id,
                                     max_results: 10,
                                     single_events: true,
                                     order_by: 'startTime',
                                     time_min: Time.now.iso8601)

      puts 'Upcoming events:'
      puts 'No upcoming events found' if response.items.empty?

      response.items
    end

    class GcalendarTokenStore < Google::Auth::TokenStore
      def initialize; end

      def load(id)
        puts "load token #{id}"
        user = User.find_by(uid: id)
        user.google_calendar_authorization.access_token
      end

      def store(id, token)
        puts "store token #{id}, #{token}"
        user = User.find_by(uid: id)
        authorization = user.google_calendar_authorization
        authorization.update!(access_token: token)
      end

      def delete(id)
        user = User.find_by(uid: id)
        authorization = user.google_calendar_authorization
        authorization.update!(access_token: nil)
      end
    end
  end
end
