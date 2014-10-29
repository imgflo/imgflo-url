{expect} = require 'chai'
imgflo = require '../index'


describe 'imgflo-url', ->

  describe 'without a config object', ->

    it 'should throw an error', ->
      exercise = ->
        imgflo null, 'passthrough'

      expect(exercise).to.throw Error, 'imgflo config object not provided'


  describe 'with a config object', ->

    context 'without a server', ->

      it 'should throw an error', ->
        exercise = ->
          config =
            key: process.env.IMGFLO_KEY
            secret: process.env.IMGFLO_SECRET

          imgflo config, 'passthrough',
            input: 'https://a.com/b.png'

        expect(exercise).to.throw Error, 'imgflo config must contain a "server" key'


    context 'without a key', ->

      it 'should throw an error', ->
        exercise = ->
          config =
            server: 'https://imgflo.herokuapp.com/'
            secret: process.env.IMGFLO_SECRET

          imgflo config, 'passthrough',
            input: 'https://a.com/b.png'

        expect(exercise).to.throw Error, 'imgflo config must contain a "key" key'


    context 'without a secret', ->

      it 'should throw an error', ->
        exercise = ->
          config =
            server: 'https://imgflo.herokuapp.com/'
            key: process.env.IMGFLO_KEY

          imgflo config, 'passthrough',
            input: 'https://a.com/b.png'

        expect(exercise).to.throw Error, 'imgflo config must contain a "secret" key'


  describe 'without imgflo params', ->

    it 'should throw an error', ->
      exercise = ->
        config =
          server: 'https://imgflo.herokuapp.com/'
          key: process.env.IMGFLO_KEY
          secret: process.env.IMGFLO_SECRET

        imgflo config, 'passthrough'

      expect(exercise).to.throw Error, 'imgflo params not provided'


  describe 'with imgflo params', ->

    context 'without an input URL', ->

      it 'should throw an error', ->
        exercise = ->
          config =
            server: 'https://imgflo.herokuapp.com/'
            key: process.env.IMGFLO_KEY
            secret: process.env.IMGFLO_SECRET

          imgflo config, 'passthrough', {}

        expect(exercise).to.throw Error, 'imgflo params must contain an "input" key'


    context 'with an input URL for a GIF image', ->

      it 'should return the same URL', ->
        config =
          server: 'https://imgflo.herokuapp.com/'
          key: process.env.IMGFLO_KEY
          secret: process.env.IMGFLO_SECRET

        url = imgflo config, 'passthrough',
          input: 'https://a.com/b.gif'

        expect(url).to.equal 'https://a.com/b.gif'


  describe 'without a graph name', ->

    it 'should throw an error', ->
      exercise = ->
        config =
          server: 'https://imgflo.herokuapp.com/'
          key: process.env.IMGFLO_KEY
          secret: process.env.IMGFLO_SECRET

        imgflo config, null,
          input: 'https://a.com/b.png'

      expect(exercise).to.throw Error, 'imgflo graph name not provided'


  describe 'with imgflo params', ->

    context 'not specifying an image format', ->

      it 'should produce the correct URL', ->
        config =
          server: 'https://imgflo.herokuapp.com/'
          key: process.env.IMGFLO_KEY
          secret: process.env.IMGFLO_SECRET

        params =
          input: 'https://pbs.twimg.com/media/BlM0d2-CcAAT9ic.jpg:large'
          color1: '#0A2A2F'
          color2: '#FDE7A0'
          srgb: true

        url = imgflo config, 'gradientmap', params

        expect(url).to.equal "https://imgflo.herokuapp.com/graph/#{process.env.IMGFLO_KEY}/#{process.env.IMGFLO_TOKEN_01}/gradientmap.jpg?input=https%3A%2F%2Fpbs.twimg.com%2Fmedia%2FBlM0d2-CcAAT9ic.jpg%3Alarge&color1=%230A2A2F&color2=%23FDE7A0&srgb=true"


    context 'specifying an image format', ->

      it 'should produce the correct URL', ->
        config =
          server: 'https://imgflo.herokuapp.com/'
          key: process.env.IMGFLO_KEY
          secret: process.env.IMGFLO_SECRET

        params =
          input: 'https://pbs.twimg.com/media/BlM0d2-CcAAT9ic.jpg:large'
          color1: '#0A2A2F'
          color2: '#FDE7A0'
          srgb: true

        url = imgflo config, 'gradientmap', params, 'png'

        expect(url).to.equal "https://imgflo.herokuapp.com/graph/#{process.env.IMGFLO_KEY}/#{process.env.IMGFLO_TOKEN_02}/gradientmap.png?input=https%3A%2F%2Fpbs.twimg.com%2Fmedia%2FBlM0d2-CcAAT9ic.jpg%3Alarge&color1=%230A2A2F&color2=%23FDE7A0&srgb=true"
