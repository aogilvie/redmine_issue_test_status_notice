module RedmineIssueTestStatusNotice
  module IssuePatch
    def self.included(base) # :nodoc:
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)

      base.class_eval do
        unloadable # Send unloadable so it will not be unloaded in development
        after_save :save_from_issue_for_test_status_notice
      end
    end

    module ClassMethods
    end

    module InstanceMethods
      def save_from_issue_for_test_status_notice
        if not @create_already_fired
          Redmine::Hook.call_hook(:redmine_issue_test_status_notice_change, { :issue => self, :journal => self.current_journal}) unless self.current_journal.nil?
        end
        return true
      end

    end
  end
end
