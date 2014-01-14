class GameWeek
  attr_reader :starts_at, :ends_at, :week_id
  
  @@week_start_day = 2 # Tuesday (days from Sunday)
  @@week_length_s = 7 * 24 * 60 * 60
  
  def initialize(game_time)
    season_starts_at = Time.parse(NflConfig.get('season', 'starts_at'))
    start_day_offset = (game_time.wday - @@week_start_day + 7) % 7
    start_time_offset = (game_time.hour * 60 * 60 + game_time.min * 60 + game_time.sec) - (season_starts_at.hour * 60 * 60)
    @starts_at = Time.at(game_time - start_time_offset - start_day_offset * 24 * 60 * 60)
    @ends_at = Time.at(@starts_at + @@week_length_s - 1)
    @week_id = ((game_time - season_starts_at) / @@week_length_s).floor + 1
  end
  
  def self.current_time
    time = Time.parse(NflConfig.get('season','current_time_override')) || Time.new
  end
  
  def self.current
    GameWeek.new(self.current_time)
  end
  
  def self.previous
    time = self.current_time
    time -= @@week_length_s
    GameWeek.new(time)
  end
  
  def previous
    GameWeek.new(@starts_at - @@week_length_s)
  end
 
end