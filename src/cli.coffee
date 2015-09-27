
imgflo = require './imgflo-url'
minimist = require 'minimist'

main = () ->
  parsed = minimist process.argv.slice(2)
  config =
    key: process.env.IMGFLO_API_KEY
    secret: process.env.IMGFLO_API_SECRET
    server: 'https://imgflo.herokuapp.com/'
  config.server = process.env.IMGFLO_API_SERVER if process.env.IMGFLO_API_SERVER?

  for k,v of config
    config[k] = null if not v # ensure non-empty

  graphname = parsed._[0]
  params = {}
  for k,v of parsed
    continue if k == '_'
    params[k] = v

  try
    url = imgflo config, graphname, params
  catch e
    process.stderr.write "ERROR: #{e.message}\n"
    process.exit 1

  process.stdout.write url

exports.main = main
  
