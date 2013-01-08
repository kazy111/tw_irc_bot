@echo off

SET HUBOT_IRC_SERVER=irc.juggler.jp
SET HUBOT_IRC_PORT=6667
SET HUBOT_IRC_USERNAME=_ircbot*
SET HUBOT_IRC_PASSWORD=
SET HUBOT_IRC_ROOMS=#kazy111
SET HUBOT_IRC_NICK=ircbot_kazy111

runcoffee.bat --nodejs --harmony-collections .\node_modules\hubot\bin\hubot -a irc -n tw_irc 2> err.txt
rem .\node_modules\.bin\hubot.cmd -a irc -n tw_irc
