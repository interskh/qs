module ApplicationHelper
  
  def sitemap(text)
    "<ul class='breadcrumb'>
      <li>#{link_to('Home', root_path)}<span class='divider'> | </span></li>
      <li>#{link_to('Foursquare', foursquare_index_path)}<span class='divider'> | </span></li>
      <li class='active'>#{text}</li>
    </ul>".html_safe
  end
  
end
