# Author::        Christopher Brito (cbrito@gmail.com)
# Original Repo:: https://github.com/cbrito/splunk-client

require File.expand_path File.join(File.dirname(__FILE__), 'splunk_results')
require File.expand_path File.join(File.dirname(__FILE__), 'splunk_job')
require File.expand_path File.join(File.dirname(__FILE__), 'splunk_alert_feed_entry')


class SplunkAlertFeed

  def initialize(alertFeedXml, clientPointer=nil)
    @alertFeedXml = alertFeedXml
    @client = clientPointer #SplunkClient object pointer for use with self.results
  end

  def totalResults
    @alertXml.css("*totalResults").text
  end
  
  def itemsPerPage
    @alertXml.css("*itemsPerPage").text
  end

  def startIndex
    @alertXml.css("*startIndex").text
  end
  
  def entries
    alertEntries = Array.new
    
    @alertFeedXml.css("entry").each do |entry|
      alertEntries.push SplunkAlertFeedEntry.new(entry, @client)
    end
    
    return alertEntries
  end
  
end #class SplunkAlertFeed
