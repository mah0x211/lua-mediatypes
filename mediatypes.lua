--
-- Copyright (C) 2022 Masatoshi Fukunaga
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--
--- modules
local error = error
local type = type
local find = string.find
local gmatch = string.gmatch
local match = string.match
local sub = string.sub
local setmetatable = setmetatable
--- constants
local DEFAULT_MIME = require('mediatypes.default')

--- split
--- @param str string
--- @param pat string
--- @return string[] arr
local function split(str, pat)
    local arr = {}
    local idx = 0
    local cur = 1
    local last = #str + 1
    local head, tail = find(str, pat, cur)

    while head do
        if head ~= cur then
            idx = idx + 1
            arr[idx] = sub(str, cur, head - 1)
        end
        cur = tail + 1
        head, tail = find(str, pat, cur)
    end

    if cur < last then
        arr[idx + 1] = sub(str, cur)
    end

    return arr
end

--- parse
--- @param mimetypes string
--- @param mime2exts table
--- @param ext2mime table
local function parse(mimetypes, mime2exts, ext2mime)
    --
    -- parses the following mime format string:
    --
    --  mime/type       ext1 ext2 ext3 # comments
    --
    -- read each line
    for line in gmatch(mimetypes, '[^\n\r]+') do
        -- remove comment line
        line = match(line, '^[^#]+')
        if line then
            local list = split(line, '%s+')
            local mime = list[1]

            -- select extension
            for i = 2, #list do
                local ext = match(list[i], '%w+')

                -- found new extension
                if ext and not ext2mime[ext] then
                    -- update exts table
                    ext2mime[ext] = mime
                    -- update types table
                    if not mime2exts[mime] then
                        mime2exts[mime] = {
                            ext,
                        }
                    else
                        mime2exts[mime][#mime2exts[mime] + 1] = ext
                    end
                end
            end
        end
    end
end

--- @class MediaType
--- @field mime2exts table<string, string[]>
--- @field ext2mime table<string, string>
local MediaType = {}
MediaType.__index = MediaType

--- getexts
--- @param mime string
--- @return string[] exts
function MediaType:getexts(mime)
    return self.mime2exts[mime]
end

--- getmime
--- @param ext string
--- @return string mime
function MediaType:getmime(ext)
    return self.ext2mime[ext]
end

--- read
--- @param mimetypes string
function MediaType:read(mimetypes)
    if type(mimetypes) ~= 'string' then
        error('mimetypes must be string')
    end
    parse(mimetypes, self.mime2exts, self.ext2mime)
end

--- new
--- @param mimetypes string
--- @return MediaType
local function new(mimetypes)
    local self = setmetatable({
        mime2exts = {},
        ext2mime = {},
    }, MediaType)

    self:read(mimetypes == nil and DEFAULT_MIME or mimetypes)

    return self
end

return {
    new = new,
}

