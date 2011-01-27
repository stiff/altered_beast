#!/bin/bash

THE_USER=$1
if [ -z $THE_USER ]; then
  THE_USER=hudson
fi

source /home/$THE_USER/.profile
source /home/$THE_USER/.bashrc
source /home/$THE_USER/.rvm/scripts/rvm

rvm use 1.8.7-p302 --verbose
rvm gemset create tectura
rvm gemset use tectura

gem install actionmailer -v=2.3.3 --no-ri --no-rdoc
gem install actionpack -v=2.3.3 --no-ri --no-rdoc
gem install activerecord -v=2.3.3 --no-ri --no-rdoc
gem install activeresource -v=2.3.3 --no-ri --no-rdoc
gem install activesupport -v=2.3.3 --no-ri --no-rdoc
gem install bluecloth -v=2.0.9 --no-ri --no-rdoc
gem install bundler -v=1.0.2 --no-ri --no-rdoc
gem install capistrano -v=2.5.19 --no-ri --no-rdoc
gem install coderay -v=0.9.5 --no-ri --no-rdoc
gem install columnize -v=0.3.1 --no-ri --no-rdoc
gem install daemons -v=1.1.0 --no-ri --no-rdoc
gem install delayed_job -v=2.0.3 --no-ri --no-rdoc
gem install exception_notification -v=2.3.3.0 --no-ri --no-rdoc
gem install highline -v=1.6.1 --no-ri --no-rdoc
gem install less -v=1.2.21 --no-ri --no-rdoc
gem install linecache -v=0.43 --no-ri --no-rdoc
gem install mislav-will_paginate -v=2.3.11 --no-ri --no-rdoc --source http://gems.github.com
gem install mutter -v=0.5.3 --no-ri --no-rdoc
gem install mysql -v=2.8.1 --no-ri --no-rdoc
gem install net-scp -v=1.0.4 --no-ri --no-rdoc
gem install net-sftp -v=2.0.5 --no-ri --no-rdoc
gem install net-ssh -v=2.0.23 --no-ri --no-rdoc
gem install net-ssh-gateway -v=1.0.1 --no-ri --no-rdoc
gem install polyglot -v=0.3.1 --no-ri --no-rdoc
gem install rack -v=1.0.1 --no-ri --no-rdoc
gem install rails -v=2.3.3 --no-ri --no-rdoc
gem install rake -v=0.8.7 --no-ri --no-rdoc
gem install RedCloth -v=4.2.3 --no-ri --no-rdoc
gem install rspec -v=1.2.4 --no-ri --no-rdoc
gem install rspec-rails -v=1.2.4 --no-ri --no-rdoc
gem install ruby-debug -v=0.10.3 --no-ri --no-rdoc
gem install ruby-debug-base -v=0.10.3 --no-ri --no-rdoc
gem install ruby-openid -v=2.1.8 --no-ri --no-rdoc
gem install ruby-recaptcha -v=1.0.2 --no-ri --no-rdoc
gem install sqlite3-ruby -v=1.3.1 --no-ri --no-rdoc
gem install treetop -v=1.4.8 --no-ri --no-rdoc

cp config/database.yml.example config/database.yml
cp config/email.yml.example config/email.yml
cp config/recaptcha.rb.example config/recaptcha.rb

rake db:migrate

rake spec