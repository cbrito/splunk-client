# Author::        Christopher Brito (cbrito@gmail.com)
# Original Repo:: https://github.com/cbrito/splunk-client

class SplunkJob
  attr_reader :jobId

  def initialize(jobId, clientPointer)
    @jobId  = jobId
    @client = clientPointer #SplunkClient object pointer
  end

  def wait
    wait_for_results
  end

  def wait_for_results
    # Wait for the Splunk search to complete
    sleep 1 until complete?
  end

  def complete?
    # Return status of job
    @client.get_search_status(@jobId).to_i == 1
  end

  def results(maxResults=0, mode=nil)
    # Return search results
    @client.get_search_results(@jobId, maxResults, mode)
  end

  def cancel
    @client.control_job(@jobId, 'cancel')
  end

end #class SplunkJob
