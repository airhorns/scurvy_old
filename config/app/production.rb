App.configure do
  # Settings specified here will take precedence over those in config/app.rb
  config.downloads = {:movie => '/var/downloads/movies/.', :music => '/var/downloads/music'}
  config.public_access = {:find => '/var/downloads/', :replace => 'http://scurvvy.info/downroads/'}

  # config.key = "value"
end
