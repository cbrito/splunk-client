# Author::        Christopher Brito (cbrito@gmail.com)
# Original Repo:: https://github.com/cbrito/splunk-client

require File.expand_path File.join(File.dirname(__FILE__), 'splunk_results')
require File.expand_path File.join(File.dirname(__FILE__), 'splunk_job')


class SplunkAlertFeedEntry

  def initialize(alertEntryXml, clientPointer=nil)
    @alertEntryXml = alertEntryXml
    @client = clientPointer #SplunkClient object pointer for use with self.results
  end

  def title
    @alertEntryXml.css("title").text
  end
  
  def alertId
    @alertEntryXml.css("id").text
  end

  def author
    @alertEntryXml.css("author > name").text
  end
  
  def updated
    @alertEntryXml.css("updated").text
  end

  def alert
    # Return the raw Splunk XML results associated with a given fired alert.
    @client.get_alert(URI.encode(title))
    #@client.get_alert(@alertEntryXml.css("link[rel='list']")[0].attributes["href"].value)
  end

  # Use method_missing magic to return Splunk field names. API documentation here:
  # http://docs.splunk.com/Documentation/Splunk/5.0.1/RESTAPI/RESTsearch#GET_alerts.2Ffired_alerts 
  #
  # Ex: splunkalert.triggered_alerts => @alertXml.css("entry")[0].xpath(".//s:key[@name='triggered_alerts']").text
  def method_missing(name, *args, &blk)
    if args.empty? && blk.nil? && @alertEntryXml.xpath(".//s:key[@name='#{name}']").text
      @alertEntryXml.xpath(".//s:key[@name='#{name}']").text
    else
      super
    end
  end

  def respond_to?(name)
    begin
      unless @alertEntryXml.xpath(".//s:key[@name='#{name}']").nil? then true else super end
    rescue NoMethodError
      super
    end
  end
  
end #class SplunkAlertFeedEntry
