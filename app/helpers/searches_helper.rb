module SearchesHelper

  # Return the model to be searched based on params.
  def search_model
    return "User"    if params[:controller] =~ /users/
    return "Message" if params[:controller] =~ /home/
    params[:model] || params[:controller].classify
  end

  def search_type
    if params[:controller] == "pages" or params[:model] == "Page"
      "microposts"
    else
      "users"
    end
  end

  # Return the partial (including path) for the given object.
  # partial can also accept an array of objects (of the same type).
  def partial(object)
    object = object.first
    klass = object.class.to_s
    dir = "searches"
    if klass == "User"
      #dir  = "users"
      part = "user"
    else
      #dir  = 'shared'
      part = "micropost"
    end
    return "#{dir}/#{part}"
  end
end

