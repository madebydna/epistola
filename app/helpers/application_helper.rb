module ApplicationHelper
  
  def excerpt_result(text, query)
    excerpted_text = excerpt(strip_tags(text), query)
    if excerpted_text.blank?
      truncate((strip_tags(text)), :length => 500)
    else
      highlight((excerpted_text), query)
    end
  end
  
end
