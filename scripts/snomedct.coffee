# Description:
#   SNOMEDCT scripts for hubot.
#
#   Further scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

# required for https calls
https = require 'https'

# required for http calls
http = require 'http'

# required to load xmpp_jid,api_id file mapping
fs = require 'fs'

# csv parser
parse = require 'csv-parse'

# Handlerbars templating engine
Handlebars = require 'handlebars'

module.exports = (robot) ->

  robot.respond /sctid (.*)/i, (res) ->
    sctid = res.match[1]
    robot.http("https://sct-rest.ihtsdotools.org/api/snomed/en-edition/v20160731/query/concepts/#{sctid}")
    .header('Accept', 'application/json')
    .get() (err, response, body) ->

      data = JSON.parse body
      res.send "For SCTID #{sctid}, the FSN is #{data.fsn} and the URL/URI is http://snomed.info/id/#{sctid}"



  robot.respond /concept (.*)/i, (res) ->
    concept = res.match[1]
    robot.http("http://browser.ihtsdotools.org/api/snomed/en-edition/v20160731/descriptions?query=#{concept}&statusFilter=activeOnly")
    .header('Accept', 'application/json')
    .get() (err, response, body) ->

      data = JSON.parse body
      res.send "For concept #{concept}, there are #{data.details.total} results and the first one has an SCTID of #{data.matches[0].conceptId} and the FSN, #{data.matches[0].fsn} with a URL/URI of http://snomed.info/id/#{data.matches[0].conceptId}"
