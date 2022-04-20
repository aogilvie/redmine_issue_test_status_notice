module RedmineIssueTestStatusNotice
  module MessageCreator

    def from(url)
      if url.include? 'slack.com/'
        return TextMessageCreator.new(Formatter::Slack.new)
      end

      return TextMessageCreator.new(Formatter::Other.new)
    end

    module_function :from

    class TextMessageCreator
      def initialize(formatter)
        @formatter = formatter
      end

      def create(issue, old_status, new_status, note)

        text = ""

        text << "Issue changed from #{@formatter.user_name old_status} to #{@formatter.user_name new_status}"
        text << @formatter.change_line
        text << "[#{@formatter.escape issue.project}] "
        text << @formatter.link("#{issue.tracker} ##{issue.id}", MessageHelper.issue_url(issue))
        text << " #{@formatter.escape issue.subject} (#{@formatter.escape issue.status})"
        text << @formatter.change_line
        text << @formatter.escape(MessageHelper.trimming(note))

        return {:text => text}
      end
    end
  end
end
