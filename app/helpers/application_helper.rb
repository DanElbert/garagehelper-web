module ApplicationHelper

  def nav_button(text, url, options = nil)
    options = options || {}
    link_to text, url, options.merge({})
  end

end
