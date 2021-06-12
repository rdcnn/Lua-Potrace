package.path = "../?.moon"
import Potrace from require "potrace"
filename = "../img/google.bmp"

pot = Potrace filename
pot\process!

out_file = io.open "output/google.svg", "w"
out_file\write pot\getSVG!
out_file\close!