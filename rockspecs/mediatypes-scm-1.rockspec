package = "mediatypes"
version = "scm-1"
source = {
    url = "git://github.com/mah0x211/lua-mediatypes.git"
}
description = {
    summary = "MIME type utility module",
    homepage = "https://github.com/mah0x211/lua-mediatypes",
    license = "MIT/X11",
    maintainer = "Masatoshi Teruya"
}
dependencies = {
    "lua >= 5.1"
}
build = {
    type = "builtin",
    modules = {
        mediatypes = "mediatypes.lua",
        ["mediatypes.default"] = "lib/default.lua",
    }
}
