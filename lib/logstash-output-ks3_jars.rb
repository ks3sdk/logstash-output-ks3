# this is a generated file, to avoid over-writing it just delete this comment
begin
  require 'jar_dependencies'
rescue LoadError
  require 'org/apache/httpcomponents/httpclient/4.3.4/httpclient-4.3.4.jar'
  require 'org/apache/httpcomponents/httpcore/4.3.2/httpcore-4.3.2.jar'
  require 'commons-logging/commons-logging/1.1.3/commons-logging-1.1.3.jar'
  require 'org/apache/commons/commons-lang3/3.7/commons-lang3-3.7.jar'
  require 'com/fasterxml/jackson/core/jackson-databind/2.3.0/jackson-databind-2.3.0.jar'
  require 'joda-time/joda-time/2.10.10/joda-time-2.10.10.jar'
  require 'com/fasterxml/jackson/core/jackson-core/2.3.0/jackson-core-2.3.0.jar'
  require 'com/ksyun/ks3-kss-java-sdk/1.0.2/ks3-kss-java-sdk-1.0.2.jar'
  require 'commons-codec/commons-codec/1.6/commons-codec-1.6.jar'
  require 'com/fasterxml/jackson/core/jackson-annotations/2.3.0/jackson-annotations-2.3.0.jar'
end

if defined? Jars
  require_jar 'org.apache.httpcomponents', 'httpclient', '4.3.4'
  require_jar 'org.apache.httpcomponents', 'httpcore', '4.3.2'
  require_jar 'commons-logging', 'commons-logging', '1.1.3'
  require_jar 'org.apache.commons', 'commons-lang3', '3.7'
  require_jar 'com.fasterxml.jackson.core', 'jackson-databind', '2.3.0'
  require_jar 'joda-time', 'joda-time', '2.10.10'
  require_jar 'com.fasterxml.jackson.core', 'jackson-core', '2.3.0'
  require_jar 'com.ksyun', 'ks3-kss-java-sdk', '1.0.2'
  require_jar 'commons-codec', 'commons-codec', '1.6'
  require_jar 'com.fasterxml.jackson.core', 'jackson-annotations', '2.3.0'
end
