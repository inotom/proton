class ApplicationController < ActionController::Base
  before_action :set_locale unless Rails.env.test?
  before_action :set_timezone
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include SessionsHelper

  private

    def set_locale
      extracted_locale = extract_locale_from_accept_language
      I18n.locale = (I18n::available_locales.include? extracted_locale.to_sym) ?
                      extracted_locale : I18n.default_locale
    end

    def extract_locale_from_accept_language
      request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    end

    # set timezone
    # timezone info from web borwser via cookie
    def set_timezone
      Time.zone = ActiveSupport::TimeZone[-1 * cookies[:tzoffset].to_i / 60] if cookies[:tzoffset]
    end
end
