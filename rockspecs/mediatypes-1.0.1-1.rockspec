package = "mediatypes"
version = "1.0.0-1"
source = {
    url = "git://github.com/mah0x211/lua-mediatypes.git",
    tag = "v1.0.1"
}
description = {
    summary = "MIME type utility module",
    homepage = "https://github.com/mah0x211/lua-mediatypes",
    license = "MIT/X11",
    maintainer = "Masatoshi Teruya"
}
dependencies = {
    "lua >= 5.1",
    "util >= 1.4.1",
}
build = {
    type = "builtin",
    modules = {
        mediatypes = "mediatypes.lua",
        ["mediatypes.default"] = "lib/default.lua",
    }
}
