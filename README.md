# SplunkClient

Ruby library for dealing with Splunk searchs and results using the Splunk REST API.

Creating and using a client is easy:
`
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
`
