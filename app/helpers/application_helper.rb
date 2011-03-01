module ApplicationHelper
  
  # Return a title on a per-page basis.
  def title
    base_title = "Market List"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
end
