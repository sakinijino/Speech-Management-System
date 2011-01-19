Speech Management System
========================

Installation
------------
1. `git clone sms.git`
2. `gem install rails -v 1.2.5` or `rake rails:freeze:edge TAG=rel_1-2-5`
3. edit `config/database.yml` if necessary
4. `rake db:migrate RAILS_ENV=production`
5. `ruby script/server -e production`

Enjoy yourself!

Admin Usage
-----------
1. Signup admin (first time only)
   > http://127.0.0.1:3000/admin_account/signup
2. Login admin
   > http://127.0.0.1:3000/admin
3. Add some users and speeches

Common Usage
------------
1. Login (after admin added users)
   > http://127.0.0.1:3000/
2. View speech list
3. Edit your speeches
4. Discuss on speeches

Screenshots
-----------
* pics in `./public/screenshots`
