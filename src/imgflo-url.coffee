'use strict'

MD5 = require 'md5'
qs = require 'query-string'
path = require 'path'
url = require 'url'

# imgflo-url
#
# @param config [Object] An dictionary containing server, key, and secret pairs.
# @param graph [String] The name of the imgflo graph.
# @param params [Object] The parameters to pass to imgflo.
# @option params input [String] The input URL to pass to imgflo.
# @param format [String] The desired format of the resulting image. e.g. 'jpg'
#   or 'png'. If not specified, the extension of the file provided as input is
#   used.
# @return [String] The imgflo URL.
#
imgflo = (config, graph, params, format) ->
  throw new Error 'imgflo config object not provided' unless config?

  {server, key, secret} = config
  throw new Error 'imgflo config must contain a "server" key' unless server?
  throw new Error 'imgflo config must contain a "key" key' unless key?
  throw new Error 'imgflo config must contain a "secret" key' unless secret?

  throw new Error 'imgflo graph name not provided' unless graph?
  throw new Error 'imgflo params not provided' unless params?

  {input} = params
  throw new Error 'imgflo params must contain an "input" key' unless input?

  parsed = url.parse input
  return input if parsed.protocol is 'data:'

  match = path.extname(parsed.pathname).match(/^\.(\w+)/)
  extension = match?[1].toLowerCase()
  return input if extension is 'gif'

  format ?= extension
  format = format.toLowerCase() if format? and typeof format is 'string'
  graph = "#{graph}.#{format}" if format?

  query = "?#{qs.stringify(params)}"
  token = MD5 "#{graph}#{query}#{secret}"

  return "#{server}graph/#{key}/#{token}/#{graph}#{query}"


module.exports = imgflo
