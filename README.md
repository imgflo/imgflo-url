# imgflo-url [![Build Status](https://travis-ci.org/the-grid/imgflo-url.svg)](https://travis-ci.org/the-grid/imgflo-url)

Conveniently produce authorized [imgflo](https://github.com/jonnor/imgflo) URLs.

## Installing

Compatible with node.js and browserify.

    npm install --save imgflo-url

## Creating a imgflo URL using API

Example in CoffeeScript

    imgflo = require 'imgflo-url'

    config =
      server: 'https://imgflo.herokuapp.com/'
      key: 'key'
      secret: 'secret'

    params =
      input: 'https://pbs.twimg.com/media/BlM0d2-CcAAT9ic.jpg:large'
      color1: '#0A2A2F'
      color2: '#FDE7A0'
      height: 200
    url = imgflo config, 'gradientmap', params

Making a GET request of `url` will fetch image from `input` URL
and process it through the `gradientmap` graph,
applying the specified parameters (in this case `color1`, `color2`, `height`).

For more examples, see the [tests](./spec/imgflo-url.coffee).

## Create an imgflo URL using commandline

    export IMGFLO_API_KEY=key
    export IMGFLO_API_SECRET=secret

    # if node modules are not on PATH already
    # PATH=${PATH}:./node_modules/.bin
    imgflo-url passthrough --input http://example.com/barbaz.png --width 300

## Running tests
Run `npm test`.
