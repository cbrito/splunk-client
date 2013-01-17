# Author::        Christopher Brito (cbrito@gmail.com)
# Original Repo:: https://github.com/cbrito/splunk-client

require File.expand_path File.join(File.dirname(__FILE__), 'splunk_results')
require File.expand_path File.join(File.dirname(__FILE__), 'splunk_job')


class SplunkAlarm

  def initialize(alarmXml, clientPointer=nil)
    @alarmXml = alarmXml
    @client = clientPointer #SplunkClient object pointer for use with self.results
  end

  def title
    @alarmXml.css("title").text
  end
  
  def alarmId
    @alarmXml.css("id").text
  end

  def author
    #nokoXml.css("entry")[1].xpath(".//s:key[@name='triggered_alert_count']").text # Really only valuable in the higher level
    #nokoXml.css("entry")[1].css("author > name").text
    @alarmXml.css("author > name").text
  end

  def published
    @alarmXml.css("published").text
  end
  
  def updated
    @alarmXml.css("updated").text
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
  # Ex: splunkAlarm.triggered_alerts => @alarmXml.css("entry")[0].xpath(".//s:key[@name='triggered_alerts']").text
  def method_missing(name, *args, &blk)
    if args.empty? && blk.nil? && @alarmXml.css("entry")[0].xpath(".//s:key[@name='#{name}']").text
      @alarmXml.css("entry")[0].xpath(".//s:key[@name='#{name}']").text
    else
      super
    end
  end

  def respond_to?(name)
    begin
      unless @alarmXml.css("entry")[0].xpath(".//s:key[@name='#{name}']").nil? then true else super end
    rescue NoMethodError
      super
    end
  end
  
end #class SplunkAlarm
