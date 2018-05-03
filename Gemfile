source 'https://rubygems.org' do

ruby '2.4.1'
# Gemfile
# ...begining of file

group :development do
  # our sqlite3 gem will only be used locally
  #   the sqlite3 gem is an adapter for sqlite
  gem "sqlite3"
end

group :production do
  # our pg gem will only be used on production
  #   the pg gem is an adapter for postgresql
  gem "pg"
end

# ...rest of file
gem 'sinatra'
gem "activerecord"
gem "sinatra-activerecord"
gem "rake"
gem "sinatra-flash"
end