class App < Configurable # :nodoc:
  # Settings in config/app/* take precedence over those specified here.
  config.name = Rails::Application.instance.class.parent.name
  config.loaded_at = Time.zone.now.iso8601
  config.downloads = {:movie => '/Users/hornairs/Code/scurvy-test/movies', :music => '/Users/hornairs/Code/scurvy-test/music'}
  config.public_access = {:find => '/Users/hornairs/Code/scurvy-test/', :replace => 'file:///Users/hornairs/Code/scurvy-test/'}
  
  config.apis = {:lastfm => "cc85b6d4313e40450230872430b4d631"}
  config.active = true
end
