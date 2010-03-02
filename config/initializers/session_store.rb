# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_scurvy_session',
  :secret => 'dc6df20a126e802b91bf241a0bf1645323c947c1e5ec94e239e28ece6afa962d0689d160fdd0660806c6bd1212049deca2761de833333d641758a1d3d3ab734b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
