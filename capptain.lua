#!/usr/bin/env carbon

-- Capptain!
-- Hosts small apps.

local appdir = arg[1] or "apps"
kvstore.set("capptain:appdir", appdir)

srv.GET("/", mw.new(function()
	local apps = (fs.list or io.list)(kvstore.get("capptain:appdir"))
	local list = {}
	for _, app in pairs(apps) do
		if app:sub(1, 1) ~= "." and app:match("%.lua$") then
			local appname = app:gsub("%.lua$", "")
			table.insert(list, tag"a"[{href=appname}](appname))
			table.insert(list, tag"br")
		end
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
	path = params("args") or "/" -- workaround to support the "namespaces"
	local app_path = kvstore.get("capptain:appdir") .. "/" .. app .. ".lua"
	if (fs.exists or os.exists)(app_path) then
		local suc, res, code, ctype
		if fs.readfile then
			local src = fs.readfile(app_path)
			local f, err = loadstring(src)
			if f then
				suc, res, code, ctype = pcall(f)
			else
				suc = false
				res = err
			end
		else
			local suc, res, code, ctype = pcall(dofile, app_path)
		end
		if not suc then
			content(doctype()(
				tag"head"(
					tag"title"("Error in App "..app)
				),
				tag"body"(
					tag"h1"("Error in App "..app),
					tag"pre"(res)
				)
			))
		else
			if res then
				content(res, code, ctype)
			end
		end
		return
	end
	content("No such app.", 404)
end

srv.GET("/:app", handler)
srv.GET("/:app/*args", handler)

if (fs.exists or os.exists)(appdir.."/.capptain_autoexec.lua") then
	print("Executing CApptain autoexec...")
	if fs.exists then
		local src = fs.readfile(appdir.."/.capptain_autoexec.lua")
		local f, err = loadstring(src)
		if f then
			f()
		else
			error(err, 0)
		end
	else
		dofile(os.pwd().."/.capptain_autoexec.lua")
	end
end

print("CApptain loaded up.")
