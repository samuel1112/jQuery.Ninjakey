###
    A Simple jQuery shortcuts library

    The MIT License (MIT)

    Copyright (c) 2014 SSSamuel

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.

    － NinjaKey->constructor
        @param
            :key shortcuts String/Array
                now support:
                    a-z,A-Z,0-9
                special keys:
                    alt,ctrl/command,shift
                    home,left,up,right,down,enter,esc,space,backspace,del
                example:
                    ctrl+alt+a, ctrl+enter, Ctrl+Shift+A
                !! NOT SUPPORT

            :selector String
                support jquery selector string

            :callback
                selector will build a jQuery object，which will be callback `this`
        @ return
            obj -> NinjaKey


    - NinjaKey::kill
        kill ninja!

    @ 2014-05-16
    @ samuel - samuel.m.shen@gmail.com
    @ version 0.0.1
###
$ = jQuery
NinjaKey_id_pool = {}

macCheck = (->
    return {} unless navigator?
    if /Mac/.test navigator.appVersion
        mac: true
    else
        {}
)()

class NinjaKey
    idGenerator = ->
        loop
            _r = 'ninja' + 'xxxxxxxxx'.replace(/[x]/g, ->
                num = Math.random() * 16 | 0;
                num.toString(16);
            );
            break if not NinjaKey_id_pool.hasOwnProperty(_r)
        _r

    parseKey = (keys)->
        keycodeMap =
            'HOME': 36
            'LEFT': 37
            'UP': 38
            'RIGHT': 39
            'DOWN': 40
            'ENTER': 13
            'ESC': 27
            'SPACE': 32
            'BACKSPACE': 8
            'DEL': 46
        conditions = []
        for key in keys
            if key
                key = key.split('+')
                key_condition = []
                fnKey = key

                fnKeyStatus = [0, 0, 0]

                for _key in fnKey
                    _key = _key.toLowerCase()
                    if _key is 'ctrl' or _key is 'command' or _key is 'cmd'
                        fnKeyStatus[0] = 1
                    else if _key is 'alt'
                        fnKeyStatus[1] = 1
                    else if _key is 'shift'
                        fnKeyStatus[2] = 1
                    else
                        _key = _key.toUpperCase()
                        if not keycodeMap.hasOwnProperty(_key)
                            key_condition.push('e.which===' + _key.charCodeAt(0))
                        else
                            key_condition.push('e.which===' + keycodeMap[_key])
                # use util function to check os
                # on mac command is normal use as command+c mean 'copy'
                # command is a metaKey
                if not macCheck.mac
                    if fnKeyStatus[0] is 1
                        key_condition.push('e.ctrlKey')
                    else key_condition.push('!e.ctrlKey')
                else
                    if fnKeyStatus[0] is 1
                        key_condition.push('e.metaKey')
                    else key_condition.push('!e.metaKey')
                if fnKeyStatus[1] is 1
                    key_condition.push('e.altKey')
                else key_condition.push('!e.altKey')
                if fnKeyStatus[2] is 1
                    key_condition.push('e.shiftKey')
                else key_condition.push('!e.shiftKey')

                conditions.push('(' + key_condition.join(' && ') + ')')

        gFunc = 'return ' + (conditions.join(' || ') or false) + ';';

        new Function('e', gFunc)

    constructor: (key, elem, callback)->
        key = if {}.toString.call(key) is '[object Array]' then key else [key]
        @__id__ = idGenerator()
        _passion = parseKey(key)
        if typeof elem isnt 'string'
            callback = elem
            elem = document

        $(document).on('keydown.' + @__id__, (e)->
            if _passion(e)
                if callback?
                    callback.call($(elem))
                false
        )

    kill: ()->
        $(document).off('keydown.' + @__id__)

window.NinjaKey = (key, elem, callback)->
    new NinjaKey(key, elem, callback)