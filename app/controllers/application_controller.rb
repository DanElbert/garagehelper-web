class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate
    if ENV["GARAGE_HELPER_PASSWORD"]
      authenticate_or_request_with_http_basic do |u, p|
        u == 'dan' && (p == ENV["GARAGE_HELPER_PASSWORD"] || is_local_request?)
      end
    else
      true
    end

  end

  protected

  def only_allow_helper
    unless request_ip_addresses.include?('10.0.0.105')
      Rails.logger.info "Rejected request from #{request.env['HTTP_X_FORWARDED_FOR']}"
      render nothing: true, status: 401
    end
  end

  def is_local_request?
    request_ip_addresses.any? { |ip| ip.start_with?('10.0.0.') || ip.start_with?('172.17.') }
  end

  def request_ip_addresses
    request.env['HTTP_X_FORWARDED_FOR'].to_s.split(',').map { |ip| ip.strip }.compact
  end

end
