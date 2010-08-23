# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_mombot_session',
  :secret      => 'dde5f1e709342c9431ecb4c743e306b2391db7e276e403972312cdd461bf6cfbff38921ba80cc92f9104f04acdd91148ff9ca83e957de7fb8c90e15e030c2295'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
