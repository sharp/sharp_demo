#!/usr/bin/env ruby

RailsRoot = File.expand_path("../../../", __FILE__)
RailsEnv = ENV['RAILS_ENV'] || 'development'

require 'active_record'
require 'active_support'
require 'logger'
require 'pg'
require 'optparse'
require 'pp'
require 'require_all' 

require_rel 'gems', 'site'
require_rel 'sites/**/*.rb' 

ActiveRecord::Base.logger = Logger.new("#{RailsRoot}/log/crawler.log")
ActiveRecord::Base.configurations = YAML::load(IO.read("#{RailsRoot}/config/database.yml"))
ActiveRecord::Base.establish_connection(RailsEnv)

def run(domain)
  pp "crawler is starting for #{domain} with #{RailsEnv}"
  site = "Crawler::Sites::#{domain.classify}".constantize.new
  site.load
end

if ['lowes.ca'].include? ARGV[0]
 run(ARGV[0].gsub(/\./, '_')) 
else
  pp "You need to pass valid params first"
end