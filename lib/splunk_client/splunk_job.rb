# Author::        Christopher Brito (cbrito@gmail.com)
# Original Repo:: https://github.com/cbrito/splunk-client

require File.expand_path File.join(File.dirname(__FILE__), 'splunk_results')


class SplunkJob
  attr_reader :jobId
  attr_accessor :succeeded

  REQUEST_LIMIT = 40
  REQUEST_WAIT_TIME = 8

  def initialize(jobId, clientPointer, wait_time_out = nil)
    @jobId  = jobId
    @client = clientPointer #SplunkClient object pointer
    @succeeded = false
    @wait_time_out = wait_time_out || REQUEST_LIMIT * REQUEST_WAIT_TIME
  end

  def wait
    wait_for_results
  end

  def wait_for_results
    request_count = 0
    until complete?
      if (request_count += 1) >= REQUEST_LIMIT || (REQUEST_WAIT_TIME * request_count) >= @wait_time_out
        cancel
        return @succeeded = false
      end
      sleep REQUEST_WAIT_TIME
    end
    @succeeded = true
  end

  def complete?
    # Return status of job
    @client.get_search_status(@jobId).to_i == 1
  end

  def results(maxResults=0, mode=nil)
    unless @succeeded
      raise SplunkWaitTimeout.new("Splunk query execution time expired. Max wait time: #{@wait_time_out} seconds")
    end

    # Return search results
    @client.get_search_results(@jobId, maxResults, mode)
  end

  def cancel
    @client.control_job(@jobId, 'cancel')
  end

  def parsedResults
    unless @succeeded
      raise SplunkWaitTimeout.new("Splunk query execution time expired. Max wait time: #{@wait_time_out} seconds")
    end

    # Return a SplunkResults object with methods for the result fields
    SplunkResults.new(results).results
  end

end #class SplunkJob
