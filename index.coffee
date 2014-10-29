MD5 = require 'MD5'
qs = require 'query-string'
path = require 'path'


# imgflo-url
#
# @param config [Object] An dictionary containing server, key, and secret pairs.
# @param graph [String] The name of the imgflo graph.
# @param params [Object] The parameters to pass to imgflo.
# @option params input [String] The input URL to pass to imgflo.
# @return [String] The imgflo URL.
#
imgflo = (config, graph, params) ->
  throw new Error 'imgflo config object not provided' unless config?

  {server, key, secret} = config
  throw new Error 'imgflo config must contain a "server" key' unless server?
  throw new Error 'imgflo config must contain a "key" key' unless key?
  throw new Error 'imgflo config must contain a "secret" key' unless secret?

  throw new Error 'imgflo graph name not provided' unless graph?
  throw new Error 'imgflo params not provided' unless params?

  {input} = params
  throw new Error 'imgflo params must contain an "input" key' unless input?

  extension = path.extname(input).match(/^\.(\w+)/)[1]
  return input if extension is 'gif'

  query = "?#{qs.stringify(params)}"
  token = MD5 "#{graph}#{query}#{secret}"

  return "#{server}graph/#{key}/#{token}/#{graph}#{query}"


module.exports = imgflo
