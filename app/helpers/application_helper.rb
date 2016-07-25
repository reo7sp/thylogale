module ApplicationHelper
  def glyphicon(name)
    "<span class=\"glyphicon glyphicon-#{name}\" aria-hidden=\"true\"></span>".html_safe
  end
end
