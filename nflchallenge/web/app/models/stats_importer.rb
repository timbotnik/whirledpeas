require 'net/http'

class StatsImporter
  @@api_config = nil
  
  def self.get_api_response(uri)
    ::Rails.logger.info('requesting api for ' + uri.to_s)
    http = Net::HTTP.new(uri.host, uri.port)
    http.read_timeout=360 # timeout in seconds. Yeah, that's 6 minutes.
    req = Net::HTTP::Get.new(uri.request_uri)
    result = http.start do |web|
      web.request(req)
    end
    JSON.parse(result.body)
  rescue => e
    ::Rails.logger.error('Error with API call:')
    ::Rails.logger.error(e)
  end
  
  def self.import_teams
    api_uri = URI::HTTP.build({
        :host => NflConfig.get('api', 'api_host'),
        :path => NflConfig.get('api', 'teams'), 
        :query => 'season=' + NflConfig.get('season', 'year')
        })
    records = get_api_response(api_uri)
    records.each do |record|
      Team.import(record)
    end
  end
  
  def self.import_games
    api_uri = URI::HTTP.build({
        :host => NflConfig.get('api', 'api_host'),
        :path => NflConfig.get('api', 'games'), 
        :query => 'season=' + NflConfig.get('season', 'year')
        })
    records = get_api_response(api_uri)
    records.each do |record|
      Game.import(record)
    end
  end
  
  def self.import_players
    api_uri = URI::HTTP.build({
        :host => NflConfig.get('api', 'api_host'),
        :path => NflConfig.get('api', 'players'), 
        :query => 'season=' + NflConfig.get('season', 'year')
        })
    records = get_api_response(api_uri)
    records.each do |record|
      Player.import(record)
    end
  end
  
  def self.import_stats(game_week)
    api_uri = URI::HTTP.build({
        :host => NflConfig.get('api', 'api_host'),
        :path => NflConfig.get('api', 'stats'), 
        :query => 'season=' + NflConfig.get('season', 'year') + '&week=' + game_week.week_id.to_s
        })
    
    records = get_api_response(api_uri)
    records_imported = 0
    if (records.count > 0)
      records.each do |game_id, stats|
        if (stats && stats.count > 2)
          GameStat.import(stats[0], game_week)
          GameStat.import(stats[1], game_week)
          for i in 2 ... stats.count
            PlayerStat.import(stats[i], game_week)
          end
        end
        records_imported += 1
      end
    end
    return records_imported
  end
  
  def self.import_stats_task
    game_week = GameWeek.previous
    stats_log = StatsLog.find_by_week_id(game_week.week_id) || StatsLog.new(:week_id => game_week.week_id)
    
    # only try importing if we are past the first week 
    # and the stats have not already been imported successfully
    try_import = game_week.week_id > 0 && (stats_log.status == :pending || stats_log.status == :error)
    if (try_import)
      begin
        stats_log.update_attributes!(:status => 'importing')
        records_imported = self.import_stats(game_week)
        if (records_imported > 0)
          stats_log.update_attributes!(:status => 'imported')
        else
          stats_log.update_attributes!(:status => 'pending')
        end
      rescue
        stats_log.update_attributes(:status => 'error')
      end
    end
  end
    
  
end