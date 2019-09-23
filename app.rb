require 'rubygems'
require 'bundler'
Bundler.require(:default)

SOURCE_URL = "https://www.facebook.com/events/ical/upcoming/?uid=$UID&key=$KEY".freeze
FB_CALENDAR_URL_REGEXP = /\A(http|https)\:\/\/(www\.)?facebook\.com\/events\/ical\/upcoming\/\?uid\=(?<uid>\S*)\&key\=(?<key>\S*)\z/.freeze

get "/" do
  haml :index
end

get "/:base64url" do
  provided_url = Base64.decode64(params['base64url'])

  return "dupa" unless FB_CALENDAR_URL_REGEXP.match?(provided_url)

  filter_going = params['going'].to_s.eql?("true") ? true : false
  filter_maybe = params['maybe'].to_s.eql?("true") ? true : false
  filter_no_response = params['no_response'].to_s.eql?("true") ? true : false

  response = HTTParty.get(provided_url)
  calendar = response.body
  cals = Icalendar::Calendar.parse(calendar)
  cal = cals.first

  going_events = cal.events.select { |e| e.custom_properties.dig("partstat").first.eql?("ACCEPTED") }
  maybe_events = cal.events.select { |e| e.custom_properties.dig("partstat").first.eql?("TENTATIVE") }
  no_response_events = cal.events.select { |e| e.custom_properties.dig("partstat").first.eql?("NEEDS-ACTION") }

  desired_events = []
  desired_events += going_events if filter_going
  desired_events += maybe_events if filter_maybe
  desired_events += no_response_events if filter_no_response

  cal.instance_variable_set(:@events, desired_events)
  cal.to_ical
end
