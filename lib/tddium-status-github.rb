dir = File.join(File.expand_path(File.dirname(__FILE__)), "tasks")

Dir.glob(File.join(dir, "*.rake")).each do |task|
  load task
end
