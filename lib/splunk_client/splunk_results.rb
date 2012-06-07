# Author::        Christopher Brito (cbrito@gmail.com)
# Original Repo:: https://github.com/cbrito/splunk-client

require 'rubygems'
require 'nokogiri'
require File.expand_path File.join(File.dirname(__FILE__), 'splunk_result')

# Simplify the calling of single result data from xpaths into an objects
class SplunkResults
  attr_reader :results

  def initialize(rawResults)
    @results = Array.new

    return @results if rawResults.strip.empty?

    nokoResults = Nokogiri::Slop(rawResults)

    if nokoResults.results.result.respond_to?("length")
      # Multiple Results, build array
      nokoResults.results.result.each do |resultObj|
        @results.push SplunkResult.new(resultObj)
      end
    else
      # Single results object
      @results.push SplunkResult.new(nokoResults.results.result)
    end
    
    return @results
  end
  
end #class SplunkResults
