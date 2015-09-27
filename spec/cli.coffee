
execFile = require('child_process').execFile
path = require 'path'
chai = require 'chai'

imgfloUrlCli = (config, graphname, params, callback) ->
  environ =
    'IMGFLO_API_KEY': config.key
    'IMGFLO_API_SECRET': config.secret
  environ.IMGFLO_API_SERVER = config.server if config.server

  prog = path.join __dirname, '../bin', 'imgflo-url'
  args = [ graphname ]
  for key, value of params
    args.push "--#{key}=#{value}"

  command = [prog].concat(args).join ' '
  #console.log 'cmd:', command  

  options =
    env: environ
  execFile prog, args, options, callback

describe 'imgflo-url CLI', ->
  validConfig =
    key: 'key'
    secret: 'secret'
  validParams =
    input: 'http://example.com/foo.png'

  describe 'calling without key', ->
    it 'should fail with helpful error', (done) ->
      imgfloUrlCli { key: '', secret: 'secret' }, 'passthrough', validParams, (err, stdout, stderr) ->
        chai.expect(err).to.exist
        chai.expect(stderr).to.include 'config must contain'
        chai.expect(stderr).to.include 'key'
        done()

  describe 'calling without secret', ->
    it 'should fail with helpful error', (done) ->
      imgfloUrlCli { key: 'key', secret: '' }, 'passthrough', validParams, (err, stdout, stderr) ->
        chai.expect(err).to.exist
        chai.expect(stderr).to.include 'config must contain'
        chai.expect(stderr).to.include 'secret'
        done()

  describe 'calling with graph but no params', ->
    it 'should fail with helpful error', (done) ->
      imgfloUrlCli validConfig, 'passthrough', {}, (err, stdout, stderr) ->
        chai.expect(err).to.exist
        chai.expect(stderr).to.include 'params must contain'
        chai.expect(stderr).to.include 'input'
        done()

  describe 'calling with graph and params', ->
    it 'should succeed with created URL', (done) ->
      params =
        input: 'https://pbs.twimg.com/media/BlM0d2-CcAAT9ic.jpg:large'
        color1: '#0A2A2F'
        color2: '#FDE7A0'
        srgb: true
      imgfloUrlCli validConfig, 'gradientmap', params, (err, stdout, stderr) ->
        chai.expect(err).to.not.exist
        chai.expect(stderr).to.equal ''
        chai.expect(stdout).to.equal "https://imgflo.herokuapp.com/graph/key/7d6ae9fbc8dadde0d1cd24526dea5900/gradientmap.jpg?input=https%3A%2F%2Fpbs.twimg.com%2Fmedia%2FBlM0d2-CcAAT9ic.jpg%3Alarge&color1=%230A2A2F&color2=%23FDE7A0&srgb=true"
        done()
