module RedmineIssueTestStatusNotice

  class IssueHookListener < Redmine::Hook::Listener

    def initialize
      @client = NoticeClient.new
      Rails.logger.debug "[RedmineIssueTestStatusNotice] IssueHookListener#initialize"
    end

    def redmine_issue_test_status_notice_change(context={})
      issue = context[:issue]
      journal = context[:journal]

      #Rails.logger.info "[RedmineIssueTestStatusNotice] IssueHookListener#redmine_issue_test_status_notice_change issue_id:#{issue.id}"

      status_journal = journal.details.find{ |detail| detail.property == 'attr' && detail.prop_key == 'status_id' }
      if status_journal.nil?
        return
      end

      on_test_status = "On Test"
      old_status = IssueStatus.find_by_id(status_journal.old_value.to_i) unless status_journal.old_value.nil?
      new_status = IssueStatus.find_by_id(status_journal.value.to_i) unless status_journal.value.nil?

      #Rails.logger.info "[RedmineIssueTestStatusNotice] IssueHookListener#redmine_issue_test_status_notice_change status:#{new_status}"

      if new_status.to_s != on_test_status
       return
      end

      notice(issue, old_status, new_status, journal.notes)
    end

    private

    def notice(issue, old_status, new_status, note)

      if Setting.plugin_redmine_issue_test_status_notice['notice_url_each_project'] == '1'
        notice_url_field = issue.project.custom_field_values.find{ |field| field.custom_field.name == 'Test Status URL' }
        notice_url = notice_url_field.value unless notice_url_field.nil?
      else
        notice_url = Setting.plugin_redmine_issue_test_status_notice['notice_url']
      end

      if notice_url.blank?
        return
      end

      message_creator = MessageCreator.from(notice_url)

      message = message_creator.create(issue, old_status, new_status, note)

      # Rails.logger.info "[RedmineIssueTestStatusNotice] IssueHookListener#notice message:#{message}"

      @client.notice(message, notice_url)
    end

  end
end
