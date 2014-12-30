-- löve2D source will not be in the love.exe directory
package.path = package.path .. arg[1] .. "/?.lua;"


require "mond"
require "realmain"