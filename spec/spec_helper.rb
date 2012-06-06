require 'rubygems'
require 'simplecov'
require 'simplecov-rcov'
class SimpleCov::Formatter::MergedFormatter
  def format(result)
    SimpleCov::Formatter::HTMLFormatter.new.format(result)
    SimpleCov::Formatter::RcovFormatter.new.format(result)
  end
end
SimpleCov.formatter = SimpleCov::Formatter::MergedFormatter
SimpleCov.start
require 'rspec/autorun'

require 'json'
require File.expand_path File.join(File.dirname(__FILE__), '../lib/splunk-client')

# Suppose you have a local Splunk instance, and have the following logs monitored:
# Source Type  |  Log file
# "syslog"     |  "/var/log/kernel.log"
# "syslog"     |  "/var/log/system.log"
# The following are the Splunk login details.
ENV['SPLUNK_USER'] = "admin"
ENV['SPLUNK_PASSWD'] =  "password"
ENV['SPLUNK_HOST'] = "localhost"
