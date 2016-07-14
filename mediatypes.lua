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
-- module
local split = require('util.string').split;
local setmetatable = setmetatable;
-- default mime
local DEFAULT_MIME = require('mediatypes.default');


-- private funcs
local function parseMIME( str, typMap, extMap )
    local list, ext, mime;

    -- mime format:
    --  mime/type       ext1 ext2 ext3; # comments
    -- read each line
    for line in string.gmatch( str, '[^\n\r]+') do
        -- not comment line
        if not line:find('^%s*#') then
            list = split( line, '%s+' );
            mime = list[1];
            -- select extension
            for i = 2, #list do
                ext = list[i]:match('%w+');
                -- found new extension
                if ext and not extMap[ext] then
                    -- update ext-map table
                    extMap[ext] = mime;
                    -- update mime-map table
                    if not typMap[mime] then
                        typMap[mime] = { ext };
                    else
                        typMap[mime][#typMap[mime] + 1] = ext;
                    end
                end
            end
        end
    end
end


-- class
local MediaType = {};


function MediaType:getExt( mime )
    return self.typMap[mime];
end


function MediaType:getMIME( ext )
    return self.extMap[ext];
end


function MediaType:readTypes( mimetypes )
    if mimetypes ~= nil and type( mimetypes ) ~= 'string' then
        error('mimetypes must be string');
    end

    parseMIME( mimetypes or DEFAULT_MIME, self.typMap, self.extMap );
end


local function new( mimetypes )
    local self = {};

    self.typMap = {};
    self.extMap = {};
    setmetatable( self, {
        __index = MediaType
    });
    self:readTypes( mimetypes );

    return self;
end

return {
    new = new
};

