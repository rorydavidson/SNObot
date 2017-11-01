# Description:
#   SNOMED CT script for hubot.
#
# Configuration:
# HUBOT_HIPCHAT_TOKEN="..."
# HUBOT_HIPCHAT_JID="..."
# HUBOT_HIPCHAT_NAME="..."
# HUBOT_HIPCHAT_PASSWORD="..."
# HUBOT_HIPCHAT_ROOMS="..."
# HUBOT_SLACK_TOKEN="..."
#
# Commands:
#   sno-bot concept <search term> - search SNOMED CT for a given term
#   sno-bot sctid <id> - return the term for the give SNOMED CT identifier
#
# Notes:
#   Currently focused on running with the HipChat & Slack adapters,
#   https://github.com/hipchat/hubot-hipchat
#   https://github.com/slackhq/hubot-slack
#
# Author:
#   rorydavidson

# required for https calls
#https = require 'https'

# required for http calls
#http = require 'http'

# required to load xmpp_jid,api_id file mapping
#fs = require 'fs'

# csv parser
#parse = require 'csv-parse'

# Handlerbars templating engine
#Handlebars = require 'handlebars'

module.exports = (robot) ->

  robot.hear /sno-bot sctid (.*)/i, (res) ->
    sctid = res.match[1]
    robot.http("https://sct-rest.ihtsdotools.org/api/snomed/en-edition/v20170731/query/concepts/#{sctid}")
    .header('Accept', 'application/json')
    .get() (err, response, body) ->

      data = JSON.parse body
      try
        res.send "For SCTID #{sctid}, the FSN is #{data.fsn} and the URL/URI is http://snomed.info/id/#{sctid}"
      catch
        res.send "Sorry, I cannot find any matching concepts for #{sctid}. Please try again."



  robot.hear /sno-bot concept (.*)/i, (res) ->
    concept = res.match[1]
    robot.http("http://browser.ihtsdotools.org/api/v2/snomed/en-edition/v20170731/descriptions?query=#{concept}&statusFilter=activeOnly")
    .header('Accept', 'application/json')
    .get() (err, response, body) ->

      data = JSON.parse body
      try
        res.send "For concept #{concept}, there are #{data.details.total} matching descriptions and the first one has an SCTID of #{data.matches[0].conceptId} and the FSN, #{data.matches[0].fsn} with a URL/URI of http://snomed.info/id/#{data.matches[0].conceptId}"
      catch error
        res.send "Sorry, I cannot find any matching descriptions for #{concept}. Please try again."
