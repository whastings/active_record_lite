Dir[File.dirname(__FILE__) + '/active_record_lite/*.rb'].each do |file|
  require file
end
