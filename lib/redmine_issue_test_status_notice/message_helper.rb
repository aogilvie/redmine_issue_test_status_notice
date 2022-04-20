module RedmineIssueTestStatusNotice
  class MessageHelper
    def self.issue_url(issue)
      "#{Setting.protocol}://#{Setting.host_name}/issues/#{issue.id}"
    end

    def self.trimming(note)
      if note.nil?
        return ''
      end

      flat = note.gsub(/\r\n|\n|\r/, ' ')
      if flat.length > 200
        flat[0, 200] + '...'
      else
        flat
      end
    end

  end
end
