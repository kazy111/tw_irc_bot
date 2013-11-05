module.exports = (robot) ->
    config = require('../config.coffee')
    encoding = require('../encoding.js').Encoding
    twitter = require('ntwitter')

    twit = new twitter(config.tokens)
    twitStream = false
    buf = []
    prevFlush = Date.now()

    if config.track == ''
        method = 'user'
        param = {}
    else
        method = 'statuses/filter'
        param = {track: config.track}


    tobyte = (text) ->
        bytes = []
        i = 0
        len = text.length
        while i < len
            bytes[bytes.length] = text.charCodeAt(i++)
        bytes

    convert = (text) ->
        bytes = tobyte(text)
        enc = encoding.convert(bytes, config.encoding)
        [encoding.codeToString(enc), enc.length]

    OutputBuffered = (header, text) ->
        buf.push(convert(header + text))
        if Date.now() - prevFlush >= config.wait
            FlushBuffer()

    FlushBuffer = () ->
        try
            len = 0
            if buf.length == 0
                return
            # while buf.length > 0 and len + buf[0][1] < 300
            if buf.length > 0
                item = buf.shift()
                len += item[1]
                for i, room of process.env.HUBOT_IRC_ROOMS.split(",")
                    if config.use_notice
                        (new robot.Response(robot, {user : {id : -1, name : room}, text : "none", done : false}, [])).notice(item[0])
                    else
                        (new robot.Response(robot, {user : {id : -1, name : room}, text : "none", done : false}, [])).send(item[0])
            prevFlush = Date.now()
        catch err
            console.error err


    OutputTimer = () ->
        setTimeout OutputTimer, config.wait
        FlushBuffer()


    Output = (header, text) ->
        try
            OutputBuffered header, text.replace /\n/g, ' '
        catch err
            console.error 'error: ' + err


    StreamSearch = () ->
        coeff = 1
        # Twitter Event Loop

        twit.stream method, param, (stream) ->
            console.log 'twitter connected'
            twitStream = stream

            stream.on 'disconnect', () ->
                console.error 'twitter disconnected...'
                if coeff <= 32
                    setTimeout StreamSearch, coeff * 10 * 1000

            stream.on 'error', (a, b, c, d) ->
                console.error 'stream error: ' + a + b
                if coeff <= 32
                    if a == 'http'
                        setTimeout StreamSearch, coeff * 10 * 1000
                        coeff *= 2
                    else
                        setTimeout StreamSearch, coeff * 250
                        coeff++

            stream.on 'end', (err) ->
                console.error 'stream end'
                console.error err if config.debug

            stream.on 'delete', (data) ->
                console.error 'delete tweet' if config.debug
                console.error data if config.debug

            stream.on 'data', (data) ->
                try
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
                catch err
                    console.error 'error: ' + err

    RestartStreamSearch = () ->
        if(twitStream && twitStream.destroy)
            twitStream.destroy()
        StreamSearch()


    # exec
    StreamSearch()
    OutputTimer()


    process.on 'uncaughtException', (err) ->
        console.error 'Caught exception: ' + err
