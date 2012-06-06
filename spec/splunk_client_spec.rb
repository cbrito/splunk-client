require File.expand_path File.join(File.dirname(__FILE__), 'spec_helper')

describe SplunkClient do

  let(:splunk_client) { SplunkClient.new(ENV['SPLUNK_USER'], ENV['SPLUNK_PASSWD'], ENV['SPLUNK_HOST']) }
  let(:search) { 'sourcetype="syslog" "kernel" earliest=-30m' }

  context "initialization" do

    it "creates a session key" do
      splunk_client.send(:get_session_key).should_not be(nil)
    end

  end

  context "searching" do

    it "creates a search job" do
      splunk_client.stub(:create_search).and_return("A search job")
      splunk_client.should_receive(:create_search).with(search)
      splunk_client.search(search).should eq("A search job")
    end

    it "executing the job returns search results" do
      job = splunk_client.search(search)
      job.wait
      job.results(0, 'json').should_not be_nil
    end

  end

  context "parsing search results" do

    let(:parsed_results) { job = splunk_client.search(search); job.wait; job.parsedResults }

    it "parses the results into an array of Splunk Result" do
      parsed_results.should be_kind_of(Array)
      parsed_results.each do |result|
        result.should be_kind_of(SplunkResult)
      end
    end

    #############################################
    #Meta fields in each of the search result
    #<field>_cd</field>
    #<field>_indextime</field>
    #<field>_raw</field>
    #<field>_serial</field>
    #<field>_si</field>
    #<field>_sourcetype</field>
    #<field>_time</field>
    #<field>host</field>
    #<field>index</field>
    #<field>linecount</field>
    #<field>source</field>
    #<field>sourcetype</field>
    #<field>splunk_server</field>
    #############################################
    #TODO: Implement those missing methods
    it "responds to method calls by the name of meta fields in the results" do
      #%w[cd indextime raw serial si sourcetype time host index linecount source splunk_server].each do |method_call|
      %w[raw sourcetype time host index linecount source splunk_server].each do |method_call|
        parsed_results.first.respond_to?(method_call).should be_true
        parsed_results.first.send(method_call.to_sym).should_not be_nil
      end
    end

  end
end
