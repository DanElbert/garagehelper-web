module ApplicationHelper

  def nav_button(text, url, options = nil)
    options = options || {}
    other_class = options[:class]
    other_method = options[:method]
    button_to text, url, options.merge({class: "btn btn-default navbar-btn #{other_class}", method: other_method ? other_method : :get})
  end

end
