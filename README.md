# SplunkClient

Ruby library for dealing with Splunk searches and results using the Splunk REST API.

## Features

* Session based authentication to Splunk REST interface
* Create and check on the status of Splunk Jobs
* Natural Ruby methods for interacting with search results (no need to parse XML or JSON or use Ruby Hashes)

## Installation

	gem install splunk-client

## Usage

Creating and using a client is easy:

	require 'rubygems' 
	require 'splunk-client'

	# Create the client
	splunk = SplunkClient.new("username", "password", "hostname")

	# Create the Search
	search = splunk.search("test_search")

	# Wait for the Splunk search to complete
	search.wait # Blocks until the search returns

	#Print the raw XML results 
	puts search.results

	# Use ruby methods for dealing with results:
	search.parsedResults.each do |result|
		puts result.host + " : " + result.time
	end

## Tips

* Want to spawn multiple jobs without blocking on each? Use `search.complete?` to poll for job status. 

* Looking for more or less results? Use `search.results(maxResults)` to control how much is returned. (A value of 0 returns all results (this is the default.))

* Access Splunk fields in results via method calls:

    result = search.parsedResults
    puts result[0].fieldName


## Revision History

#### 0.6
* Added two new objects: SplunkResults and SplunkResult for to support:
* Accessing Splunk fields via method calls

	search.parsedResults.each {|result| puts result.$$FIELD_NAME$$}

#### 0.5
WARNING: Compatibility with prior versions will break as SplunkClient no longer returns a sid. It now returns a SplunkJob object.

* Separated SplunkClient and SplunkJob into two separate objects. 

#### 0.1
* Initial Release
