#!/usr/bin/env carbon

-- Capptain!
-- Hosts small apps.

kvstore.set("capptain:appdir", arg[1] or "./apps")

srv.GET("/", mw.new(function()
	local apps = (fs.list or io.list)("./apps")
	local list = {}
	for _, app in pairs(apps) do
		local appname = app:gsub("%.lua$", "")
		table.insert(list, tag"a"[{href=appname}](appname))
		table.insert(list, tag"br")
	end
	content(doctype()(
		tag"head"(
			tag"title" "CApptain | App List"
		),
		tag"body"(
			tag"h1" "Welcome to CApptain! This is the current App List:",
			tag"br",
			unpack(list)
		)
	))
end, {page=mainpage}))

handler = function()
	local app = params("app")
	local apps = (fs.list or io.list)("./apps")
	for k, v in pairs(apps) do
		if v == app..".lua" then
			local suc, res, code, ctype = pcall(dofile, kvstore.get("capptain:appdir") .. "/"..app..".lua")
			if not suc then
				content(doctype()(
					tag"head"(
						tag"title" "Error in App "..app
					),
					tag"body"(
						tag"h1" "Error in App "..app,
						res
					)
				))
			else
				if res then
					content(res, code, ctype)
				end
			end
			return
		end
	end
	content("No such app.", 404)
end

srv.GET("/:app", handler)
srv.GET("/:app/*args", handler)

print("CApptain loaded up.")
