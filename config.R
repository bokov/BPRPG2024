# Don't use this file directly. Copy it to local.config.R and make your changes
# there. Do not check local.config.R into git repos, it's for you to use and 
# customize locally.

# Obtain your token by loading up googlesheets4 in an interactive session and 
# using this command: gs4_auth(email='YOUREMAIL@gmail.com',cache ='.secrets')
# You will be prompted to log into Google. After successful login and 
# authorization your token will be created in the '.secrets' folder which will
# also be created if it doesn't exist yet. Look for a file that looks like
# 'e4356efger0982y34erpsdgy0w9e8r_YOUREMAIL@gmail.com'. It's an RDS file, you
# can rename it to anything you want, for example .secrets/MYTOKEN.rds
# Do NOT share that file, and do NOT check it into any git repos.
token <- readRDS('.secrets/MYTOKEN.rds');

# To get the Google Sheets ID of the workbook to which you want to write, run
# gs4_find(n_max=10). The first column of output will contain the names you gave
# your workbooks and the second will contain their IDs. Copy and paste the one
# you want into a quoted string that gets assigned to gsid below. If you don't
# see your workbook, keep increasing the value of n_max until you do.
gsid <- 'w09y87yt23rpofdguidsfg90werwerg';

# This is just the name of the sheet in the workbook to which you want to append
# data. Sheet1 if you didn't explicitly give it a name.
gssheet <- 'characters';

# As of right now the sheet you write to should have columns 
# timestamp, charid, charname, archetype, debuff, skill1, skill2, skill3
c()