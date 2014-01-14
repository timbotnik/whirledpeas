class NflConfig
  @@config = nil
  
  def self.get(category, field)
    if (@@config == nil)
      @@config = YAML::load(File.open(::Rails.root.to_s + '/config/nfl.yml'))
    end
    if (@@config.has_key?(category) && @@config[category].has_key?(field))
      return @@config[category][field]
    else
      return nil;
    end
  end
  
end