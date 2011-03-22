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
  
  def breadcrumbs(*links)
    "<div class='breadcrumbs'>" +
      links.map {|x|
        x.is_a?(Array) ? link_to(x[0].to_s, x[1]) : x
      }.join(" &gt; ") +
      "</div>"
  end
  
end
