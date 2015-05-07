{expect} = require 'chai'
imgflo = require '../index'

getConfig = ->
  server: 'https://imgflo.herokuapp.com/'
  key: 'key'
  secret: 'secret'

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
            key: 'key'
            secret: 'secret'

          imgflo config, 'passthrough',
            input: 'https://a.com/b.png'

        expect(exercise).to.throw Error, 'imgflo config must contain a "server" key'


    context 'without a key', ->

      it 'should throw an error', ->
        exercise = ->
          config =
            server: 'https://imgflo.herokuapp.com/'
            secret: 'secret'

          imgflo config, 'passthrough',
            input: 'https://a.com/b.png'

        expect(exercise).to.throw Error, 'imgflo config must contain a "key" key'


    context 'without a secret', ->

      it 'should throw an error', ->
        exercise = ->
          config =
            server: 'https://imgflo.herokuapp.com/'
            key: 'key'

          imgflo config, 'passthrough',
            input: 'https://a.com/b.png'

        expect(exercise).to.throw Error, 'imgflo config must contain a "secret" key'


  describe 'without imgflo params', ->

    it 'should throw an error', ->
      exercise = ->
        config = getConfig()

        imgflo config, 'passthrough'

      expect(exercise).to.throw Error, 'imgflo params not provided'


  describe 'with imgflo params', ->

    context 'without an input URL', ->

      it 'should throw an error', ->
        exercise = ->
          config =
            server: 'https://imgflo.herokuapp.com/'
            key: 'key'
            secret: 'secret'

          imgflo config, 'passthrough', {}

        expect(exercise).to.throw Error, 'imgflo params must contain an "input" key'


    context 'with an input URL for a GIF image', ->

      it 'should return the same URL', ->
        config = getConfig()

        url = imgflo config, 'passthrough',
          input: 'https://a.com/b.gif'

        expect(url).to.equal 'https://a.com/b.gif'


  describe 'without a graph name', ->

    it 'should throw an error', ->
      exercise = ->
        config = getConfig()

        imgflo config, null,
          input: 'https://a.com/b.png'

      expect(exercise).to.throw Error, 'imgflo graph name not provided'


  describe 'with imgflo params', ->

    context 'not specifying an image format', ->

      it 'should produce the correct URL', ->
        config = getConfig()

        params =
          input: 'https://pbs.twimg.com/media/BlM0d2-CcAAT9ic.jpg:large'
          color1: '#0A2A2F'
          color2: '#FDE7A0'
          srgb: true

        url = imgflo config, 'gradientmap', params

        expect(url).to.equal "https://imgflo.herokuapp.com/graph/key/7d6ae9fbc8dadde0d1cd24526dea5900/gradientmap.jpg?input=https%3A%2F%2Fpbs.twimg.com%2Fmedia%2FBlM0d2-CcAAT9ic.jpg%3Alarge&color1=%230A2A2F&color2=%23FDE7A0&srgb=true"


      context 'with a url with query parameters', ->

        it 'should produce the correct URL', ->
          config =
            server: 'https://imgflo.herokuapp.com/'
            key: 'key'
            secret: 'secret'

          params =
            input: 'https://v.cdn.vine.co/r/videos/B5B06468B91176403722801139712_342c9a1c624.1.5.15775156368984795444.mp4.jpg?versionId=edU_LrAtIFsGvZj.Fgi0Si1bem68tBlk'

          url = imgflo config, 'passthrough', params

          expect(url).to.equal "https://imgflo.herokuapp.com/graph/key/0256dbdaea357ae9928f19c50d3d088a/passthrough.jpg?input=https%3A%2F%2Fv.cdn.vine.co%2Fr%2Fvideos%2FB5B06468B91176403722801139712_342c9a1c624.1.5.15775156368984795444.mp4.jpg%3FversionId%3DedU_LrAtIFsGvZj.Fgi0Si1bem68tBlk"

      context 'with a url with uppercase JPG extension', ->

        it 'should produce the correct URL', ->
          config = getConfig()

          params =
            input: 'http://1.bp.blogspot.com/-1h8jX1lfGJc/UnlTZ3Fsq6I/AAAAAAAAAOo/dw7IXnJBO5A/s1600/IMG_1722.JPG'

          url = imgflo config, 'passthrough', params

          expect(url).to.contain 'passthrough.jpg'
          expect(url).to.equal 'https://imgflo.herokuapp.com/graph/key/e48c2b3866af0e91fb4b1ef4d5399b7d/passthrough.jpg?input=http%3A%2F%2F1.bp.blogspot.com%2F-1h8jX1lfGJc%2FUnlTZ3Fsq6I%2FAAAAAAAAAOo%2Fdw7IXnJBO5A%2Fs1600%2FIMG_1722.JPG'

      context 'with a url without an extension', ->

        it 'should produce the correct URL', ->
          config = getConfig()

          params =
            input: 'https://lh6.ggpht.com/qhLc1KUYP3YpNUtf9MujZVld1ctgsU0_oEEqp6Jkte8hW1UNJqKSm9-ExP-uzyL3r2c=h556'
            color1: '#0A2A2F'
            color2: '#FDE7A0'
            srgb: true

          url = imgflo config, 'gradientmap', params

          expect(url).to.equal 'https://imgflo.herokuapp.com/graph/key/79e7c60252e6d0b804c555b818b8b50f/gradientmap?input=https%3A%2F%2Flh6.ggpht.com%2FqhLc1KUYP3YpNUtf9MujZVld1ctgsU0_oEEqp6Jkte8hW1UNJqKSm9-ExP-uzyL3r2c%3Dh556&color1=%230A2A2F&color2=%23FDE7A0&srgb=true'

    context 'specifying an image format', ->

      it 'should produce the correct URL', ->
        config = getConfig()

        params =
          input: 'https://pbs.twimg.com/media/BlM0d2-CcAAT9ic.jpg:large'
          color1: '#0A2A2F'
          color2: '#FDE7A0'
          srgb: true

        url = imgflo config, 'gradientmap', params, 'png'

        expect(url).to.equal "https://imgflo.herokuapp.com/graph/key/c681f4fad93f8fb1e5e9333a22b7f760/gradientmap.png?input=https%3A%2F%2Fpbs.twimg.com%2Fmedia%2FBlM0d2-CcAAT9ic.jpg%3Alarge&color1=%230A2A2F&color2=%23FDE7A0&srgb=true"
