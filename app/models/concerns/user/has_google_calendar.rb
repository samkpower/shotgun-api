class User
  module HasGoogleCalendar
    extend ActiveSupport::Concern

    GOOGLE_CALENDAR_READ_ONLY_SCOPE = ::Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY
    GOOGLE_CALENDAR_CALLBACK_URI = 'http://localhost:3000/authorizations/callbacks'.freeze
    GOOGLE_CALENDAR_OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze

    def google_calendar_authorization
      authorizations.where("'https://www.googleapis.com/auth/calendar.readonly' = ANY (scopes)")&.first
    end

    def get_gcal_credentials
      authorizer = Google::Auth::UserAuthorizer.new(
        ::GOOGLE_CLIENT_ID,
        GOOGLE_CALENDAR_READ_ONLY_SCOPE,
        GcalendarTokenStore.new
      )
      credentials = authorizer.get_credentials(uid)
      credentials
    end

    def guarantee_gcal_authorization!
      return google_calendar_authorization if google_calendar_authorization.present?
      google_authorization
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
        user = User.find_by!(uid: id)
        user.google_calendar_authorization&.access_token
      end

      def store(id, token)
        puts "store token #{id}, #{token}"
        user = User.find_by!(uid: id)
        # TODO: use another storage method
        google_authorization = guaranteed_google_authorization
        existing_scopes = google_authorization.scopes.dup
        google_authorization.update!(scopes: existing_scopes += [GOOGLE_CALENDAR_READ_ONLY_SCOPE])
        authorization.update!(access_token: token)
      end

      def delete(id)
        user = User.find_by!(uid: id)
        authorization = user.google_calendar_authorization
        authorization.update!(access_token: nil)
      end
    end
  end
end
