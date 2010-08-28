# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_apify-test_session',
  :secret      => 'bddecc0f5cf89605f636b60d93fc7afe99a1c98025b0349dd98e75728fcda44eea74b349d86af242509cccfd09481fc4f145eb100460c60678feb2a74444f131'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
