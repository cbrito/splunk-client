require File.expand_path File.join(File.dirname(__FILE__), 'spec_helper')

describe SplunkClient do

<<<<<<< HEAD
  before :each do
    @user = ENV['SPLUNK_USER']
    @pass = ENV['SPLUNK_PASSWD']
    @host = ENV['SPLUNK_HOST']
    @splunk_client = SplunkClient.new(@user, @pass, @host)
  end
=======
  let(:splunk_client) { SplunkClient.new(splunk_user, splunk_passwd, splunk_host) }
  let(:search) { 'sourcetype="syslog" "kernel" earliest=-30m' }
>>>>>>> 3225437... Updated spec tests, removed debugger from gemspec.

  context "initialization" do

    it "creates a session key" do
      splunk_client = @splunk_client
      splunk_client.should_not be(nil)
      splunk_client.send(:get_session_key).should_not be(nil)
    end

  end

  context "searching" do

    it "creates a search job and returns results" do
      splunk_client = @splunk_client
      splunk_client.should_not be(nil)
      search = 'source="/var/log/messages" "kernel" earliest=-10m'
      job = splunk_client.search(search)
      job.should_not be(nil)
      job.wait
      job.results(0, 'json')
      job.cancel
    end

  end
  
  context "parsing_results" do
    it "uses the parsedResults 'host' method of a SplunkJob" do
      splunk_client = @splunk_client
      splunk_client.should_not be(nil)
      search = 'source="/var/log/messages" "kernel" earliest=-10m'
      job = splunk_client.search(search)
      job.should_not be(nil)
      job.wait
      results = job.parsedResults
      
      # Test the auto generated methods
      results.each do |result|
        result.respond_to?("time").should be(true)
        result.respond_to?("raw").should be(true)
        result.respond_to?("host").should be(true)
        result.time.should_not be(nil)
        result.raw.should_not be(nil)
        result.host.should_not be(nil)
      end

<<<<<<< HEAD
=======
    it "responds to method calls by the name of meta fields in the results" do
      %w[raw sourcetype time host index linecount source splunk_server].each do |method_call|
        parsed_results.first.respond_to?(method_call).should be_true
        parsed_results.first.send(method_call.to_sym).should_not be_nil
      end
>>>>>>> 3225437... Updated spec tests, removed debugger from gemspec.
    end
  end

end
