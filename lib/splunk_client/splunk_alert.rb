# Author::        Christopher Brito (cbrito@gmail.com)
# Original Repo:: https://github.com/cbrito/splunk-client

require File.expand_path File.join(File.dirname(__FILE__), 'splunk_results')
require File.expand_path File.join(File.dirname(__FILE__), 'splunk_job')


class SplunkAlert

  def initialize(alertXml, clientPointer=nil)
    @alertXml = alertXml
    @client = clientPointer #SplunkClient object pointer for use with self.results
  end

  def title
    @alertXml.css("title").text
  end
  
  def alertId
    @alertXml.css("id").text
  end

  def author
    @alertXml.css("author > name").text
  end

  def published
    @alertXml.css("published").text
  end
  
  def updated
    @alertXml.css("updated").text
  end

  def results
    # Return the raw Splunk XML results associated with a given fired alert.
    SplunkJob.new(self.sid, @client).results
  end
  
  def parsedResults
    # Returns an array of SplunkResult objects
    SplunkJob.new(self.sid, @client).parsedResults
  end

  # Use method_missing magic to return Splunk field names. API documentation here:
  # http://docs.splunk.com/Documentation/Splunk/5.0.1/RESTAPI/RESTsearch#GET_alerts.2Ffired_alerts 
  #
  # Ex: splunkalert.triggered_alerts => @alertXml.css("entry")[0].xpath(".//s:key[@name='triggered_alerts']").text
  def method_missing(name, *args, &blk)
    if args.empty? && blk.nil? && @alertXml.xpath(".//s:key[@name='#{name}']").text
      @alertXml.xpath(".//s:key[@name='#{name}']").text
    else
      super
    end
  end

  def respond_to?(name)
    begin
      unless @alertXml.xpath(".//s:key[@name='#{name}']").nil? then true else super end
    rescue NoMethodError
      super
    end
  end
  
end #class SplunkAlert
