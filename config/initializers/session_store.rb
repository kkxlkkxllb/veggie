# Be sure to restart your server when you modify this file.

#Veggie::Application.config.session_store :cookie_store, key: '_veggie_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
Veggie::Application.config.session_store :redis_store
