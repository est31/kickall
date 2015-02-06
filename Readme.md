# A mod for kicking all players

Copyright 2015 est31.
License: LGPLv2+

Dependencies: none

## Features:

 - Automatically kicks all connected players without the `nokickall` priv on server shutdown. This can be turned off by the `kickall.no_kick_on_shutdown` setting.
 - Adds 3 new commands: `/kickall <reason>`, `/reallykickall <reason>` and `/kshutdown <reason>`

If you want to shut down the server and send the players a custom message e.g. do `/kshutdown Restarting server, reconnect in a minute.`. If you want to get kicked yourself, too, just revoke your `nokickall` privilege, or use `/reallykickall`.

## Commands

 - `/kickall <reason>` kicks all players without the `nokickall`
 - `/reallykickall <reason>` kicks all players regardless of their `nokickall` priv
 - `/kshutdown <reason>` kicks all players without the `nokickall` and shuts down the server