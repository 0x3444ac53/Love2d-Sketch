fennel = require("lib.fennel")
table.insert(package.loaders, fennel.make_searcher({ correlate = true }))

require("wrap")
