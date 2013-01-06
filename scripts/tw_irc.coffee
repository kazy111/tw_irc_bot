module.exports = (robot) ->
    config = require('../config.coffee')
    encoding = require('../encoding.js').Encoding
    twitter = require('ntwitter')

    twit = new twitter(config.tokens)
    twitStream = false

    tobyte = (text) ->
        bytes = []
        i = 0
        len = text.length
        while i < len
            bytes[bytes.length] = text.charCodeAt(i++)
        bytes

    convert = (text) ->
        bytes = tobyte(text)
        encoding.codeToString(encoding.convert(bytes, config.encoding))

    Output = (header, text) ->
        arr = text.split "\n"
        for k, v of arr
            #console.log(header + v)
            for i, room of process.env.HUBOT_IRC_ROOMS.split(",")
                (new robot.Response(robot, {user : {id : -1, name : room}, text : "none", done : false}, [])).send(convert(header + v))

    StreamSearch = () ->
        coeff = 1
        # Twitter Event Loop
        twit.stream 'user', {}, (stream) ->
            console.log('twitter connected')
            twitStream = stream

            stream.on 'disconnect', () ->
                console.log('twitter disconnected...')
                if coeff <= 32
                    setTimeout StreamSearch, coeff * 10 * 1000

            stream.on 'error', (a, b, c, d) ->
                console.log('stream error: ' + a + b)
                if coeff <= 32
                    if a == 'http'
                        setTimeout StreamSearch, coeff * 10 * 1000
                        coeff *= 2
                    else
                        setTimeout StreamSearch, coeff * 250
                        coeff++

            stream.on 'end', (err) ->
                console.log 'stream end'
                console.log err if config.debug

            stream.on 'delete', (data) ->
                console.log 'delete tweet' if config.debug
                console.log data if config.debug

            stream.on 'data', (data) ->
                if data.text
                    Output data.user.screen_name + ': ', data.text
                else if config.event_enable && data.event
                    text = data.source.screen_name
                    if data.target_object.text
                        text += ': ' + data.target_object.text
                    else if data.target_object.full_name
                        text += ': ' + data.target_object.full_name
                    text = '' if !text
                    Output data.event + ' event - ', text


    RestartStreamSearch = () ->
        if(twitStream && twitStream.destroy)
            twitStream.destroy()
        StreamSearch()


    # init
    StreamSearch()
