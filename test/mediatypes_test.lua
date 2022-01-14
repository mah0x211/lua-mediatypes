local testcase = require('testcase')
local mediatypes = require('mediatypes');

function testcase.new()
    -- test that create mediatype object
    local m = mediatypes.new()
    assert(m)

    -- test that create mediatype object with custom mimetypes
    m = assert(mediatypes.new([[
        my/mimetype     my myfile;    # my custom mime-type
    ]]))
    assert.equal(m.ext2mime, {
        my = 'my/mimetype',
        myfile = 'my/mimetype',
    })
    assert.equal(m.mime2exts, {
        ['my/mimetype'] = {
            'my',
            'myfile',
        },
    })

    -- test that throws an error with invalid argument
    for _, v in ipairs({
        1,
        {},
        true,
        false,
        coroutine.create(function()
        end),
    }) do
        local err = assert.throws(mediatypes.new, v)
        assert.match(err, 'mimetypes must be string')
    end
end

function testcase.getmime()
    local m = assert(mediatypes.new([[
        # JavaScript
        application/javascript js;
        application/json json;
        my/mimetype     my myfile;    # my custom mime-type
    ]]))

    -- test that return mime type associated with extension
    for ext, mime in pairs({
        my = 'my/mimetype',
        myfile = 'my/mimetype',
        js = 'application/javascript',
        json = 'application/json',
    }) do
        assert.equal(m:getmime(ext), mime)
    end
end

function testcase.getexts()
    local m = assert(mediatypes.new([[
        # JavaScript
        application/javascript js;
        application/json json;
        my/mimetype     my myfile;    # my custom mime-type
    ]]))

    -- test that return extensions associated with mime type
    for mime, exts in pairs({
        ['my/mimetype'] = {
            'my',
            'myfile',
        },
        ['application/javascript'] = {
            'js',
        },
        ['application/json'] = {
            'json',
        },
    }) do
        assert.equal(m:getexts(mime), exts)
    end
end
