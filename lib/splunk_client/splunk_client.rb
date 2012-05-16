# Author::        Christopher Brito (cbrito@gmail.com)
# Original Repo:: https://github.com/cbrito/splunk-client

require 'net/https'
require 'cgi'
require 'rubygems'
require 'nokogiri'
require File.expand_path File.join(File.dirname(__FILE__), 'splunk_job')

class SplunkClient

  def initialize(username, password, host, port=8089)
    @USER=username; @PASS=password; @HOST=host; @PORT=port

    @SESSION_KEY = { 'authorization' => "Splunk #{get_session_key}" }
  end

  def search(search)
    create_search(search)
  end

  def create_search(search)
    # Returns a SplunkJob 
    xml = splunk_post_request("/services/search/jobs",
                              "search=#{CGI::escape("search #{search}")}",
                              @SESSION_KEY)

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

  def control_job(sid, action)
    xml = splunk_post_request("/services/search/jobs/#{sid}/control",
                              "action=#{CGI::escape(action)}",
                              @SESSION_KEY)
    @doc = Nokogiri::Slop(xml)
  end

  private ###############################################################################

  def splunk_http_request
    http = Net::HTTP.new(@HOST, @PORT)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    return http
  end

  def splunk_get_request(path)
    splunk_http_request.get(path, @SESSION_KEY).body
  end

  def splunk_post_request(path, data=nil, headers=nil)
    splunk_http_request.post(path,data,headers).body
  end

  def get_session_key
    xml = splunk_post_request("/services/auth/login",
                              "username=#{@USER}&password=#{@PASS}")
    @doc = Nokogiri::Slop(xml)
    return @doc.xpath("//sessionKey").text
  end

end #class SplunkClient
