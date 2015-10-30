# Author::        Christopher Brito (cbrito@gmail.com)
# Original Repo:: https://github.com/cbrito/splunk-client

require 'net/https'
require 'cgi'
require 'rubygems'
require 'nokogiri'
require 'uri'
require File.expand_path File.join(File.dirname(__FILE__), 'splunk_job')
require File.expand_path File.join(File.dirname(__FILE__), 'splunk_alert')
require File.expand_path File.join(File.dirname(__FILE__), 'splunk_alert_feed')

class SplunkClient

  def initialize(username, password, host, port=8089, proxy_url = '', read_time_out = 60, use_ssl = true)
    @USER=username; @PASS=password; @HOST=host; @PORT=port; @READ_TIMEOUT = read_time_out
    @PROXY_URI = URI(proxy_url) if proxy_url && !proxy_url.empty?
    @use_ssl = use_ssl

    sessionKey = get_session_key

    if (sessionKey == "")
      raise SplunkSessionError, 'Session key is invalid. Please check your username, password and host'
    else
      @SESSION_KEY = { 'authorization' => "Splunk #{sessionKey}" }
    end
  end

  def search(search, start_time = nil, end_time = nil, query_prefix = 'search')
    create_search(search, start_time, end_time, query_prefix)
  end

  # Returns a SplunkJob
  def create_search(search, start_time = nil, end_time = nil, query_prefix = 'search')
    start_time, end_time = start_time.to_s, end_time.to_s
    data_string = "search=#{CGI::escape("#{query_prefix} #{search}")}"
    data_string += "&earliest_time=#{CGI.escape(start_time)}" unless end_time.empty?
    data_string += "&latest_time=#{CGI.escape(end_time)}" unless end_time.empty?

    xml = splunk_post_request("/services/search/jobs", data_string, @SESSION_KEY)
    @doc = Nokogiri::Slop(xml)

    return SplunkJob.new(@doc.xpath("//sid").text, self)
  end

  def get_search_status(sid)
    xml = splunk_get_request("/services/search/jobs/#{sid}")
    @doc = Nokogiri::Slop(xml)
    return @doc.xpath("//s:key[@name='isDone']").text
  end

  def get_search_results(sid, maxResults=0, mode=nil)
    url = "/services/search/jobs/#{sid}/results?count=#{maxResults}"
    url += "&output_mode=#{mode}" unless mode.nil?
    splunk_get_request(url)
  end

  def get_alert_list(user="nobody", count=30)
    xml = splunk_get_request("/servicesNS/#{user}/search/alerts/fired_alerts?count=#{count}")
    SplunkAlertFeed.new(Nokogiri::Slop(xml), self)
  end

  def get_alert(alarmName, user="nobody")
    xml = splunk_get_request("/servicesNS/#{user}/search/alerts/fired_alerts/#{alarmName}")
    SplunkAlert.new(Nokogiri::Slop(xml).css("entry")[0], self)
  end

  def control_job(sid, action)
    xml = splunk_post_request("/services/search/jobs/#{sid}/control",
                              "action=#{CGI::escape(action)}",
                              @SESSION_KEY)
    @doc = Nokogiri::Slop(xml)
  end

  private ###############################################################################

  def splunk_http_request()
    if @PROXY_URI
      http = Net::HTTP.new(@HOST, @PORT, @PROXY_URI.host, @PROXY_URI.port)
    else
      http = Net::HTTP.new(@HOST, @PORT, nil)
    end
    http.read_timeout = @READ_TIMEOUT
    http.use_ssl = @use_ssl
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http
  end

  def splunk_get_request(path)
    result = splunk_http_request.get(path, @SESSION_KEY.merge({'Content-Type' => 'application/x-www-form-urlencoded'})).body
    raise SplunkEmptyResponse, 'Splunk response is empty.' unless result
    result
  end

  def splunk_post_request(path, data=nil, headers=nil)
    result = splunk_http_request.post(path,data,headers).body
    raise SplunkEmptyResponse, 'Splunk response is empty.' unless result
    result
  end

  def get_session_key
    xml = splunk_post_request("/services/auth/login",
                              "username=#{@USER}&password=#{@PASS}")
    @doc = Nokogiri::Slop(xml)
    return @doc.xpath("//sessionKey").text
  end

end #class SplunkClient

class SplunkSessionError < SecurityError
  # Exception class for handling invalid session tokens received by the gem
end

class SplunkWaitTimeout < Exception
  # Raised when splunk request times out
end

class SplunkEmptyResponse < Exception
  # Raised when splunk response is empty
end
