# SplunkClient

Ruby library for dealing with Splunk searches and results using the Splunk REST API.

Creating and using a client is easy:

	require 'splunk-client.rb'

	# Create the client
	splunk = SplunkClient.new("username", "password", "hostname")

	# Create the Search
	search = splunk.create_search("test_search")

	# Wait for the Splunk search to complete
	search.wait_for_results

	#Print the results 
	puts search.results

## Tips

* Want to spawn multiple jobs without blocking on each? Use `search.complete?` to poll for job status. 

* Looking for more or less results? Use `search.results(maxResults)` to control how much is returned. (A value of 0 returns all results (this is the default.))

## Revision History

#### 0.5
WARNING: Compatibility with prior versions will break as SplunkClient no longer returns a sid. It now returns a SplunkJob object.

* Separated SplunkClient and SplunkJob into two separate objects. 

#### 0.1
* Initial Release