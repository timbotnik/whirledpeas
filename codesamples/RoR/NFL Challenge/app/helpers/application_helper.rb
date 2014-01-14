module ApplicationHelper
  
  def format_time(dt)
    dt.strftime('%D')
  end
  
  def days_left(dt)
    days_left = (dt.to_i - Time.now.to_i)/86400
    "#{days_left} days from now" #if days_left > 0
  end
  
  def fb_avatar(fb_id)
    image_tag "http://graph.facebook.com/#{fb_id}/picture"
  end
  
  def get_photo(id)
    "http://static.nfl.com/static/content/public/image/getty/headshot/#{id[0]}/#{id[1]}/#{id[2]}/#{id}.jpg"
  end
  
  def get_team_photo(team)
    image_tag "http://static.nfl.com/static/site/img/logos/65x90/#{team}.png"
  end
  
end