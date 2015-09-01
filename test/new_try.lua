local MediaTypes = require('mediatypes');

for _, arg in ipairs({
    1,
    {},
    true,
    false,
    coroutine.create(function()end)
}) do
    ifTrue( isolate( MediaTypes.new, arg ) );
end

ifNotTrue( isolate( MediaTypes.new, '' ) );
ifNil( MediaTypes.new );



