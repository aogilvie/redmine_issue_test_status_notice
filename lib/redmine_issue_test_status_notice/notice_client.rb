require 'httpclient'

module RedmineIssueTestStatusNotice
  class NoticeClient
    def notice(message, url)

      Rails.logger.debug "[RedmineIssueTestStatusNotice] NoticeClient#notice url:#{url}"

      begin
        client = HTTPClient.new
        client.ssl_config.cert_store.set_default_paths
        client.ssl_config.ssl_version = :auto
        conn = client.post_async url, message.to_json, {'Content-Type' => 'application/json; charset=UTF-8'}

        Thread.new do
          begin
            res = conn.pop
            if !HTTP::Status.successful?(res.status) 
              Rails.logger.warn("[RedmineIssueTestStatusNotice] Failed request to #{url}")
              Rails.logger.warn(res.inspect)
              return
            end

            Rails.logger.debug "[RedmineIssueTestStatusNotice] NoticeClient#notice success"

          rescue Exception => e
            Rails.logger.warn("[RedmineIssueTestStatusNotice] Failed request to #{url}")
            Rails.logger.warn(e.inspect)
          end
        end

      rescue Exception => e
        Rails.logger.warn("[RedmineIssueTestStatusNotice] Failed request to #{url}")
        Rails.logger.warn(e.inspect)
      end
    end
  end
end
