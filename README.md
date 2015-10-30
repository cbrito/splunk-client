# SplunkClient

Ruby library for dealing with Splunk searches and results using the Splunk REST API.

## Features

* Session based authentication to Splunk REST interface
* Create and check on the status of Splunk Jobs
* Retrieve Splunk alerts
* Natural Ruby methods for interacting with search results (no need to parse XML or JSON or use Ruby Hashes)

## Installation

	gem install splunk-client

## Usage

Creating and using a client is easy:

	require 'rubygems' 
	require 'splunk-client'

	# Create the client
    splunk = SplunkClient.new(username: "username", password: "password", host: "hostname")
    options for SplunkClient.new:
    * username *
    * password *
    * host *
    * port (default 8089)
    * proxy_url (default '')
    * use_ssl (default true)
    * read_time_out (default 60)
    * wait_time_out (default 320)


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

Working with Splunk alerts:

    # Create the client
    splunk = SplunkClient.new(username: "username", password: "password", host: "hostname")
	
	# Fetch all the open alerts
	alertEntries = splunk.get_alert_list.entries
	
	# What's the name of this alert?
	alertEntries[1].alert.title
	
	# What time did a particular alert trigger?
	alertEntries[1].alert.trigger_time_rendered
	
	# How many times has a particular alert fired?
	alertEntries[1].alert.triggered_alerts
	
	# Fetch the raw XML results of the alert
	alertEntries[1].alert.results
	
	# Work with the results as a Ruby object
	alertEntries[1].alert.parsedResults

## Tips

* Want to spawn multiple jobs without blocking on each? Use `search.complete?` to poll for job status. 

* Looking for more or less results? Use `search.results(maxResults)` to control how much is returned. (A value of 0 returns all results (this is the default.))

* Access Splunk fields in results via simple method calls

      `result = search.parsedResults`
      `puts result[0].fieldName`

## FAQ

#### What is Splunk?

I'm making an assumption that if you are looking for a Ruby client to interact with Splunk's REST API, you have some idea of what Splunk does. If not, you should totally check it out. It makes working with logs awesome. 

http://www.splunk.com

#### Where can I find information on Splunk's REST API and the methods available in this gem?

The Splunk REST API reference can be found here:
http://docs.splunk.com/Documentation/Splunk/5.0.1/RESTAPI/RESTsearch

This gem currently only provides access to the /search/ and /alerts/ APIs. The gem attempts to make use of `method_missing` to implement ruby methods where fields are returned from a given Splunk search. 

#### Why do I get an exception when using `wait` on a search?

Very little excetption handling occurs with-in the gem. It is up to consumers to ensure they have appropriate network connectivity to their splunk endpoint, and that the credentials are correct. 

Insufficient network connectivity will raise a `TimeOut` exception. 

Incorrect credentials will raise a Nokogiri error referencing `Undefined namespace prefix: //s:key[@name='isDone']`

## Revision History

### 1.0.0

* Refactored the growing list of items to pass into `SplunkClient.new` into an options hash.

### 0.10

* Added support for turning off SSL `use_ssl`

#### 0.9

* Added support for HTTP proxy servers and read timeouts.

#### 0.8

* Added preliminary GET support for alarms within the Splunk REST API

TODO: Write test-cases for alerts methods.

#### 0.7

* Added alias support for raw field 
* Added test cases for all Splunk meta fields

#### 0.6

* Added two new objects: SplunkResults and SplunkResult for to support:
* Accessing Splunk fields via method calls

    
      search.parsedResults.each {|result| puts result.$$FIELD_NAME$$}



#### 0.5
WARNING: Compatibility with prior versions will break as SplunkClient no longer returns a sid. It now returns a SplunkJob object.

* Separated SplunkClient and SplunkJob into two separate objects. 

#### 0.1

* Initial Release


## Versioning

As of 0.5, this software uses [Semantic Versioning](http://semver.org/). Basically, this means that any given minor release number is backwards compatible. Patch releases are just that, and major releases **may** break compatibility. 

If you contribute to this software, and I hope you do, please leave the VERSION file alone. Alternatively, update the VERSION file in a commit on it's own, so that we can cherry-pick around it when merging code. 

# License

This software is released under the MIT License (ref: LICENSE) 
