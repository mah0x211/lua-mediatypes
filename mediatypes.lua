--[[

  Copyright (C) 2014 Masatoshi Teruya

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.

  mediatypes.lua
  lua-mediatypes
  Created by Masatoshi Teruya on 14/07/04.

--]]
--- modules
local strfind = string.find;
local strsub = string.sub;
local strmatch = string.match;
local strgmatch = string.gmatch;
--- constants
local DEFAULT_MIME = require('mediatypes.default');


--- split
-- @param str
-- @param pat
-- @return arr
local function split( str, pat )
    local arr = {};
    local idx = 0;
    local cur = 1;
    local last = #str + 1;
    local head, tail = strfind( str, pat, cur );

    while head do
        if head ~= cur then
            idx = idx + 1;
            arr[idx] = strsub( str, cur, head - 1 );
        end
        cur = tail + 1;
        head, tail = strfind( str, pat, cur );
    end

    if cur < last then
        arr[idx + 1] = strsub( str, cur );
    end

    return arr;
end


--- parse
-- @param mimetypes
-- @param mime2exts
-- @param ext2mime
local function parse( mimetypes, mime2exts, ext2mime )
    -- parse following mime format:
    --  mime/type       ext1 ext2 ext3; # comments
    -- read each line
    for line in strgmatch( mimetypes, '[^\n\r]+' ) do
        -- remove comment line
        line = strmatch( line, '^[^#;]+' )
        if line then
            local list = split( line, '%s+' );
            local mime = list[1];

            -- select extension
            for i = 2, #list do
                local ext = strmatch( list[i], '%w+' );

                -- found new extension
                if ext and not ext2mime[ext] then
                    -- update exts table
                    ext2mime[ext] = mime;
                    -- update types table
                    if not mime2exts[mime] then
                        mime2exts[mime] = { ext };
                    else
                        mime2exts[mime][#mime2exts[mime] + 1] = ext;
                    end
                end
            end
        end
    end
end


-- class
local MediaType = {};


--- getexts
-- @param mime
-- @return exts
function MediaType:getexts( mime )
    return self.mime2exts[mime];
end


--- getmime
-- @param ext
-- @return mime
function MediaType:getmime( ext )
    return self.ext2mime[ext];
end


--- read
-- @param mimetypes
function MediaType:read( mimetypes )
    if type( mimetypes ) == 'string' then
        parse( mimetypes, self.mime2exts, self.ext2mime );
    else
        error('mimetypes must be string');
    end
end


--- new
-- @param mimetypes
-- @return MediaType
local function new( mimetypes )
    local self = {};

    self.mime2exts = {};
    self.ext2mime = {};
    setmetatable( self, {
        __index = MediaType
    });
    self:read( mimetypes == nil and DEFAULT_MIME or mimetypes );

    return self;
end


return {
    new = new
};

