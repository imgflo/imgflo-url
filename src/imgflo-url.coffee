'use strict'

# Tiny MD5 function from js-crypto by James Taylor
# https://github.com/jbt/js-crypto/blob/master/md5.js 
MD5 = `function(){for(var m=[],l=0;64>l;)m[l]=0|4294967296*Math.abs(Math.sin(++l));return function(c){var e,g,f,a,h=[];c=unescape(encodeURI(c));for(var b=c.length,k=[e=1732584193,g=-271733879,~e,~g],d=0;d<=b;)h[d>>2]|=(c.charCodeAt(d)||128)<<8*(d++%4);h[c=16*(b+8>>6)+14]=8*b;for(d=0;d<c;d+=16){b=k;for(a=0;64>a;)b=[f=b[3],(e=b[1]|0)+((f=b[0]+[e&(g=b[2])|~e&f,f&e|~f&g,e^g^f,g^(e|~f)][b=a>>4]+(m[a]+(h[[a,5*a+1,3*a+5,7*a][b]%16+d]|0)))<<(b=[7,12,17,22,5,9,14,20,4,11,16,23,6,10,15,21][4*b+a++%4])|f>>>32-b),e,g];for(a=4;a;)k[--a]=k[a]+b[a]}for(c="";32>a;)c+=(k[a>>3]>>4*(1^a++&7)&15).toString(16);return c}}();`

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

  return input if input.substring(0, 5) is 'data:'
  return input if input.substring(0, 5) is 'blob:'

  # Remove protocol
  if index = input.indexOf('//') < 7
    input = input.substring(index + 2)

  # Find directories
  dirs = input.split('/')

  # Extract filename and query
  [last, qs] = dirs[dirs.length - 1].split('?')

  # Cleanup twitter file names like image.jpg:large
  last = last.split(':')[0]

  # Find extension
  format ?= last.match(/\.(\w+)$/)?[1].toLowerCase()
  format = format.toLowerCase() if format? and typeof format is 'string'

  switch format
    when 'tif'
      format = 'png'
    when 'gif'
      graph = 'noop'
      params = 
        input: params.input

  graph = "#{graph}.#{format}" if format?

  # Serialize query string
  for param in Object.keys(params).sort()
    if query
      query += '&'
    else
      query = "?"
    query += param + '=' + encodeURIComponent(params[param])

  token = MD5 "#{graph}#{query}#{secret}"

  return "#{server}graph/#{key}/#{token}/#{graph}#{query}"


module.exports = imgflo
