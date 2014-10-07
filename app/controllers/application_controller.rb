class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  if ENV["GARAGE_HELPER_PASSWORD"]
    http_basic_authenticate_with name: "dan", password: ENV["GARAGE_HELPER_PASSWORD"]
  end
end
