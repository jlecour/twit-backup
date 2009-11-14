class ConfigStore
  attr_reader :file
  
  def initialize(file)
    @file = file
  end
  
  def load
    if @config.nil?
      default = {
        'token' => 'ustQvL0JbIhYLQMobvFdTw',
        'secret' => '8emrPRJ3ccB1MN6PwlN7EdIluyvarG9Ptove4WEes'
      }
      if File.exists? file
        @config = YAML::load(open(file)) || default
      else
        @config = default
      end
    end
    self
  end
  
  def [](key)
    load
    @config[key]
  end
  
  def []=(key, value)
    @config[key] = value
  end
  
  def delete(*keys)
    keys.each { |key| @config.delete(key) }
    save
    self
  end
  
  def update(c={})
    @config.merge!(c)
    save
    self
  end
  
  def save
    File.open(file, 'w') { |f| f.write(YAML.dump(@config)) }
    self
  end
end