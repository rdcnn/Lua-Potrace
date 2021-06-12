package.path = "../?.lua"
local Potrace = require("potrace").Potrace
local filename = "../img/instagram.bmp"

local pot = Potrace(filename)
pot:process()

local out_file = io.open("output/instagram.svg", "w")
out_file:write(pot:getSVG())
out_file:close()