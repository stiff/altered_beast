#!/bin/bash

source /home/hudson/.profile
source /home/hudson/.bashrc
source /home/hudson/.rvm/scripts/rvm

rvm use 1.8.7-p174 --verbose
rvm gemset create tectura
rvm gemset use tectura --verbose
gem install actionmailer -v=2.3.3
gem install actionpack -v=2.3.3
gem install activerecord -v=2.3.3
gem install activeresource -v=2.3.3
gem install activesupport -v=2.3.3
gem install bluecloth -v=2.0.9
gem install bundler -v=1.0.2
gem install capistrano -v=2.5.19
gem install coderay -v=0.9.5
gem install columnize -v=0.3.1
gem install daemons -v=1.1.0
gem install delayed_job -v=2.0.3
gem install exception_notification -v=2.3.3.0
gem install highline -v=1.6.1
gem install less -v=1.2.21
gem install linecache -v=0.43
gem install mislav-will_paginate -v=2.3.11
gem install mutter -v=0.5.3
gem install mysql -v=2.8.1
gem install net-scp -v=1.0.4
gem install net-sftp -v=2.0.5
gem install net-ssh -v=2.0.23
gem install net-ssh-gateway -v=1.0.1
gem install polyglot -v=0.3.1
gem install rack -v=1.0.1
gem install rails -v=2.3.3
gem install rake -v=0.8.7
gem install RedCloth -v=4.2.3
gem install rspec -v=1.2.4
gem install rspec-rails -v=1.2.4
gem install ruby-debug -v=0.10.3
gem install ruby-debug-base -v=0.10.3
gem install ruby-openid -v=2.1.8
gem install ruby-recaptcha -v=1.0.2
gem install sqlite3-ruby -v=1.3.1
gem install treetop -v=1.4.8