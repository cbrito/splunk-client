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

# Source Type  |  Log file
# "syslog"     |  "/var/log/kernel.log"
# "syslog"     |  "/var/log/system.log"

# The following are the Splunk login details.
def splunk_user
  ENV['SPLUNK_USER'] || "admin"
end

def splunk_passwd
  ENV['SPLUNK_PASSWD'] || "changeme"
end

def splunk_host
  ENV['SPLUNK_HOST'] || "localhost"
end

def splunk_use_ssl
  ENV['USE_SSL'] || false
end