# CApptain

CApptain is a *tiny* micro app server for [Carbon](https://github.com/vifino/carbon).

# Running

`carbon -port 1337 capptain.lua`

# Apps

To make CApptain any useful, you have to add apps.

A simplistic app would be something like this:

```lua
return "Hello world!"
```

Just `return content, [responsecode, content_type]`. Simple as that.

You can do more advanced logic easily. The full path is stored in `path`, url scheme is stored in `scheme` and similar with `host`.

To just get the arguments after this app (It would be `/appname/something` otherwise), you can just use `params("args")`.

If you have trouble knowing who you are, try `params("app")` to get the app name.

You can use everything [Carbon](https://github.com/vifino/carbon) has to offer.

# License
MIT
