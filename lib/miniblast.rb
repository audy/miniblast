Dir.glob(File.join(File.dirname(__FILE__), 'miniblast', '*')).each do |f|
  require f
end