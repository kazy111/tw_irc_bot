#!/bin/sh

export HUBOT_IRC_SERVER="c.ustream.tv"
export HUBOT_IRC_PORT="6667"
export HUBOT_IRC_USERNAME="_ircbot*"
export HUBOT_IRC_PASSWORD=""
export HUBOT_IRC_ROOMS="#kazy"
export HUBOT_IRC_NICK="ircbot"

coffee --nodejs --harmony-collections ./node_modules/hubot/bin/hubot -a irc -n tw_irc
