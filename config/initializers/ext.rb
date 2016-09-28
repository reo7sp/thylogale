Dir[Rails.root.join('lib/ext/*.rb')].each do |file|
  require file
end