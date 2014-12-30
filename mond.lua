do 
	local expandOperator = function(str, operator, opInExpansion)			
			str = str:gsub("([_%a][_%w]*)%s*" .. operator, "%1 = %1" .. opInExpansion)
			return str
	end
	
	local compiler = function(codeString)
		-- FIXME: Also does this in strings
		codeString = expandOperator(codeString, "%+=", "+")
		codeString = expandOperator(codeString, "%-=", "-")
		codeString = expandOperator(codeString, "%*=", "*")
		codeString = expandOperator(codeString, "/=", "/")
		return codeString
	end
	
	local loader = function(modulename)
		local modulepath = modulename:gsub("%.", "/")
		errmsg = ""
		for path in string.gmatch(package.mondpath, "(.-);") do
			local filename = string.gsub(path, "%?", modulepath)
			local file = io.open(filename, "rb")
			if file then -- if this is used for .lua-files (not .mond) the function should throw an error if file is nil
				return assert(loadstring(compiler(assert(file:read("*a"))), filename))
			end
			errmsg = errmsg .. "\n\t Couldn't find module named " .. modulename
		end
		return errmsg == "" and nil or errmsg 
	end
	
	-- substitute package.path once and reuse for every require
	if not package.mondpath then
		package.mondpath = package.path
		--package.mondpath = ""
		--for path in string.gmatch(package.path, "(.-)%.lua;") do
		--	package.mondpath = package.mondpath .. path .. ".mond;"
		--end
	end
	
	-- only add loader if not already added
	for i = 1, #package.loaders do
		if package.loaders[i] == loader then
			return false
		end
	end
	
	-- add just before the default loader
	table.insert(package.loaders, 2, loader)
	return true
end