require 'redmine'

require File.expand_path('../lib/redmine_issue_test_status_notice/issue_patch', __FILE__)
require File.expand_path('../lib/redmine_issue_test_status_notice/issue_hook_listener', __FILE__)
require File.expand_path('../lib/redmine_issue_test_status_notice/notice_client', __FILE__)

Redmine::Plugin.register :redmine_issue_test_status_notice do
  name 'Redmine Issue Test Status Notice plugin'
  author 'aogilvie'
  description 'A plugin that notifies you that issue status is in test.'
  version '1.0.0'
  url 'https://github.com/aogilvie/redmine_issue_test_status_notice'
  author_url 'https://github.com/aogilvie'

  settings :default => { 'notice_url' => '' }, :partial => 'settings/redmine_issue_test_status_notice_settings'
end

require 'issue'
unless Issue.included_modules.include? RedmineIssueTestStatusNotice::IssuePatch
  Issue.send(:include, RedmineIssueTestStatusNotice::IssuePatch)
end
