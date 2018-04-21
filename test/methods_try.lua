local MediaTypes = require('mediatypes');
local mimetypes = [[
    my/mimetype     my myfile;
]];
local mt;

-- create mediatype object
mt = ifNil( MediaTypes.new() );
-- invalid mimetypes argument
for _, arg in ipairs({
    1,
    {},
    true,
    false,
    coroutine.create(function()end)
}) do
    ifTrue( isolate( mt.readTypes, mt, arg ) );
end

ifNotNil( mt:getmime('my') );
ifNotNil( mt:getmime('myfile') );
ifNotNil( mt:getexts('my/mimetype') );
mt:read( mimetypes );
ifNotEqual( mt:getmime('my'), 'my/mimetype' );
ifNotEqual( mt:getmime('myfile'), 'my/mimetype' );
ifNotEqual( mt:getexts('my/mimetype'), { 'my', 'myfile' } );

-- read mimetypes on initialize
mt = ifNil( MediaTypes.new( mimetypes ) );
ifNotEqual( mt:getmime('my'), 'my/mimetype' );
ifNotEqual( mt:getmime('myfile'), 'my/mimetype' );
ifNotEqual( mt:getexts('my/mimetype'), { 'my', 'myfile' } );

