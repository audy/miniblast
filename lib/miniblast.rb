Dir.glob(File.join(File.dirname(__FILE__), 'miniblast', '*.rb')).each do |f|
  require f
end