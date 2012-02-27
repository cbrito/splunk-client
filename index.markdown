---
title: Splunk REST Client for Ruby
---
# Splunk REST Client for Ruby

Library for interacting with Splunks REST API using Ruby.

Code on GitHub: [https://github.com/cbrito/splunk-client](https://github.com/cbrito/splunk-client)

## Example Client: 
	require 'splunk-client.rb'

	# Create the client
	splunk = SplunkClient.new("username", "password", "hostname")

	# Create the Search
	search = splunk.create_search("test_search")

	# Wait for the Splunk search to complete
	search.wait_for_results

	#Print the results 
	puts search.results

