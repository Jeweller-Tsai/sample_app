module ApplicationHelper
  #Return a title on per-page basis
  def title
    base_title="Ruby on Rails Tutorial Sample App"
    if @title.nil?
      base_title
    else
      "#{base_title}|#{@title}"
    end
  end

  #Return the logo image
  def logo
     logo=image_tag("rails.png" , :alt=>"Sample app" ,:class=>"round")
  end
end
