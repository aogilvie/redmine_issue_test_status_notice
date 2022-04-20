# Redmine issue test status notice plugin

It is a plugin that notifies Slack, Rocket.Chat, Teams, Google Chat, Mattermost, etc. that the issue status is now test.

## Installation

Clone this repository to the Redmine plugin directory.
Then use `bundle install` to install the dependent libraries.

```
cd {RAILS_ROOT}/plugins
git clone https://github.com/onozaty/redmine_issue_test_status_notice.git
bundle install
```

## Development

Add this folder to a "plugins" folder.
From the (parent) plugins folder run:

```
docker run -d --name postgres -e POSTGRES_PASSWORD=secret -e POSTGRES_USER=redmine postgres
docker run -d --name redmine -p 3000:3000 --link postgres:postgres -v $(pwd):/usr/src/redmine/plugins redmine
```

you may need to restart redmine

`docker restart redmine`

navigate to `localhost:3000`. Default initial user is admin admin.
