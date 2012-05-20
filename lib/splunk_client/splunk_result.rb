# Author::        Christopher Brito (cbrito@gmail.com)
# Original Repo:: https://github.com/cbrito/splunk-client

# Simplify the calling of single result data from xpaths into an object
# http://stackoverflow.com/questions/2240535/how-do-i-use-hash-keys-as-methods-on-a-class
class SplunkResult

  def initialize(nokogiriNode)
    @result = nokogiriNode
  end
  
  # Ex: splunkResult.time => nokogiriNode.result.field("[@k=\"_time\"]").value.text  
  def time
    @result.field("[@k=\"_time\"]").value.text
  end

  # Ex: splunkResult.sourceIp => nokogiriNode.field("[@k=\"sourceIp\"]").value.text
  def method_missing(name, *args, &blk)
    if args.empty? && blk.nil? && @result.field("[@k=\"#{name}\"]")
      @result.field("[@k=\"#{name}\"]").value.text
    else
      super
    end
  end
  
  def respond_to?(name)
    begin
      unless @result.field("[@k=\"#{name}\"]").nil? then true else super end
    rescue NoMethodError
      super
    end
  end
  
end #class SplunkResult
