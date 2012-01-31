# Splunk REST Client for Ruby

Library for interacting with Splunks REST API using Ruby.

Code on GitHub: https://github.com/cbrito/splunk-client

## Example Client: 

	require 'splunk-client.rb'

	# Create the client
	splunk = SplunkClient.new("username", "password", "hostname")

	# Create the Search
	searchSid = splunk.create_search("test_search")

	# Wait for the Splunk search to complete
	while (splunk.get_search_status(searchSid).to_i == 0)
	  puts "Waiting for #{searchSid} to complete..."
	  sleep 2
	end

	#Print the results 
	puts splunk.get_search_results(searchSid)

