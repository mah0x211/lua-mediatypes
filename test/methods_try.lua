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

ifNotNil( mt:getMIME('my') );
ifNotNil( mt:getMIME('myfile') );
ifNotNil( mt:getExt('my/mimetype') );
mt:readTypes( mimetypes );
ifNotEqual( mt:getMIME('my'), 'my/mimetype' );
ifNotEqual( mt:getMIME('myfile'), 'my/mimetype' );
ifNotEqual( mt:getExt('my/mimetype'), { 'my', 'myfile' } );

-- read mimetypes on initialize
mt = ifNil( MediaTypes.new( mimetypes ) );
ifNotEqual( mt:getMIME('my'), 'my/mimetype' );
ifNotEqual( mt:getMIME('myfile'), 'my/mimetype' );
ifNotEqual( mt:getExt('my/mimetype'), { 'my', 'myfile' } );

