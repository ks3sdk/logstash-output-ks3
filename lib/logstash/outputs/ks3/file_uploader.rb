# encoding: utf-8
require 'java'
java_import 'com.ksyun.ks3.dto.ObjectMetadata'
java_import 'java.io.FileInputStream'
java_import 'com.ksyun.ks3.service.request.PutObjectRequest'

module LogStash
  module Outputs
    class Ks3
      class FileUploader
        TIME_BEFORE_RETRY_SECONDS = 3

        attr_reader :ks3, :bucket, :additional_ks3_settings, :logger

        def initialize(ks3, bucket, additional_ks3_settings, logger, thread_pool)
          @ks3 = ks3
          @bucket = bucket
          @additional_ks3_settings = additional_ks3_settings
          @logger = logger
          @thread_pool = thread_pool
        end

        def upload_async(file, options = {})
          @thread_pool.post do
            LogStash::Util.set_thread_name("Logstash KS3 Output Plugin: output uploader, file: #{file.path}")
            upload(file, options)
          end
        end

        def upload(file, options = {})
          meta = ObjectMetadata.new
          meta.setContentLength(file.size)
          unless @additional_ks3_settings.nil?
            if @additional_ks3_settings.include?(LogStash::Outputs::Ks3::SERVER_SIDE_ENCRYPTION_ALGORITHM_KEY)
              unless @additional_ks3_settings[LogStash::Outputs::Ks3::SERVER_SIDE_ENCRYPTION_ALGORITHM_KEY].empty?
                meta.setSseAlgorithm(@additional_ks3_settings[LogStash::Outputs::Ks3::SERVER_SIDE_ENCRYPTION_ALGORITHM_KEY])
              end
            end
          end

          stream = nil
          begin
            stream = FileInputStream.new(file.path)
            logger.info("metaData: ", :meta => meta)
            putObjectRequest = PutObjectRequest.new(@bucket, file.key, stream, meta)
            ks3.putObject(putObjectRequest)
          rescue Errno::ENOENT => e
            logger.error("Logstash KS3 Output Plugin: file to be uploaded doesn't exist!", :exception => e.class, :message => e.message, :path => file.path, :backtrace => e.backtrace)
          rescue => e
            @logger.error("Logstash KS3 Output Plugin: uploading failed, retrying.", :exception => e.class, :message => e.message, :path => file.path, :backtrace => e.backtrace)
            sleep TIME_BEFORE_RETRY_SECONDS
            retry
          ensure
            unless stream.nil?
              stream.close
            end
          end

          options[:on_complete].call(file) unless options[:on_complete].nil?
          rescue => e
            logger.error("Logstash KS3 Output Plugin: an error occurred in the `on_complete` uploader", :exception => e.class, :message => e.message, :path => file.path, :backtrace => e.backtrace)
            raise e
        end

        def close
          @thread_pool.shutdown
          @thread_pool.wait_for_termination(nil)
        end
      end
    end
  end
end