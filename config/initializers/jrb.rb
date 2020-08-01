RjbLoader.before_load do |config|
  config.java_options += ['-Xmx4g']
end