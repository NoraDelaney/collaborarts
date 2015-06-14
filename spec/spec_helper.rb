require 'pry'
require 'rspec'
require 'capybara/rspec'

require_relative '../server.rb'

Capybara.app = Sinatra::Application
