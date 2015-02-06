--------------------------------
-- Kickall mod, (c) 2015 est31 -
--------------------------------
-- This file comes to you under the terms of the LGPLv2+ license

local kickall = {}

kickall.__iskickshutdown = false

function kickall.kickall(playerfrom, reason, reallyall, shutdown)
	local defaultreason = minetest.setting_get("kickall.def_reason") or "%s kicking all players"
	local defaultshutdownreason = minetest.setting_get("kickall.def_shutdown_reason") or "%s kicking all players due to shutdown."
	if shutdown and playerfrom == nil then
		minetest.log("action", "Kicking players due to shutdown...")
	else
		minetest.log("action", "Player " .. playerfrom .. " kicks " .. (reallyall and "really all " or "normal ") .. "Players".. (shutdown and " and shuts the server down," or "") .." with reason: " .. reason)
	end
	if not reason or reason == "" then
		reason = playerfrom and (shutdown and defaultshutdownreason or defaultreason) or "Server shutting down."
	end
	reason = reason:format(playerfrom)
	for _,player in pairs(minetest.get_connected_players()) do
		local name = player:get_player_name()
		local privs = minetest.get_player_privs(name)
		if not privs.nokickall or reallyall  then
			minetest.kick_player(name, reason)
		else
			minetest.chat_send_player(name, "All players except those with the nokickall priv got kicked.")
		end
	end
end

minetest.register_privilege("nokickall", "Holders of this priv are spared from admins kicking them, when they kick all players.")

minetest.register_chatcommand("kickall", {
	params = "<reason>",
	description = "Kicks all players except those with the nokickall priv.",
	privs = {server = true},
	func = function(name, reason)
		kickall.kickall(name, reason, false, false)
	end
})

minetest.register_chatcommand("kickreallyall", {
	params = "<reason>",
	description = "Kicks all connected players, including those with the nokickall priv.",
	privs = {server = true},
	func = function(name, reason)
		kickall.kickall(name, reason, true, false)
	end
})

minetest.register_chatcommand("kshutdown", {
	params = "<reason>",
	description = "Kicks all players without the nokickall priv and shuts the server down.",
	privs = {server = true},
	func = function(name, reason)
	kickall.__iskickshutdown = true
	kickall.kickall(name, reason, false, true)
		minetest.request_shutdown()
	end
})

if not minetest.setting_getbool("kickall.no_kick_on_shutdown") == true then
	minetest.register_on_shutdown(function()
		if not kickall.__iskickshutdown then
			kickall.kickall(nil, "Shutting down server.", false, true)
		end
	end)
end
