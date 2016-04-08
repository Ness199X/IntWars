
enet_proto = Proto("enet", "ENET LoL UDP Protocol")

MAX_ITEM_LABEL_LENGTH = 240
MIN_PORT = 5000
MAX_PORT = 6000

b64key = ""
b64keyfile = ""

package.cpath = package.cpath .. ";" .. USER_DIR .. "plugins\\enet\\?.dll"

require "blowfish"

command2string = {
	[0] = "NONE",
	[1] = "ACKNOWLEDGE",
	[2] = "CONNECT",
	[3] = "VERIFY_CONNECT",
	[4] = "DISCONNECT",
	[5] = "PING",
	[6] = "SEND_RELIABLE",
	[7] = "SEND_UNRELIABLE",
	[8] = "SEND_FRAGMENT",
	[9] = "SEND_UNSEQUENCED",
	[10] = "BANDWIDTH_LIMIT",
	[11] = "THROTTLE_CONFIGURE",
	[99] = "UNKNOWN COMMAND (THIS IS AN ERROR)",
}
pf_checksum = ProtoField.new("Checksum", "enet_proto.checksum", ftypes.UINT32)
pf_flag_has_sent_time = ProtoField.new("'Sent Time'-Flag", "enet_proto.flag_sent_time", ftypes.BOOLEAN)
pf_peer_id = ProtoField.new("Peer Id", "enet_proto.peer_id", ftypes.UINT16)
pf_sent_time = ProtoField.new("Sent Time", "enet_proto.sent_time", ftypes.UINT16)
pf_seqnumber = ProtoField.new("Sequence number", "enet_proto.seqnumber", ftypes.UINT16)
pf_command = ProtoField.new("Command", "enet_proto.command", ftypes.UINT8, command2string, base.DEC, 0x0f)
pf_channel = ProtoField.new("ChannelID", "enet_proto.channel", ftypes.UINT8)
pf_proto_header = ProtoField.new("ENET Protocol Header", "enet_proto.proto_header", ftypes.BYTES, nil, base.NONE)
pf_header = ProtoField.new("ENET Command Header", "enet_proto.header", ftypes.BYTES, nil, base.NONE)
pf_data_length = ProtoField.new("Data length", "enet_proto.data_length", ftypes.UINT16)
pf_data = ProtoField.new("LoL Data", "enet_proto.data", ftypes.BYTES)
pf_data_decrypted = ProtoField.new("Decrypted Payload", "enet_proto.data.decrypted", ftypes.BYTES)
pf_key = ProtoField.new("LoL Game Key", "enet_proto.key", ftypes.STRING)

pf_ack = ProtoField.new("Acknowledge", "enet_proto.acknowledge", ftypes.BYTES, nil, base.NONE)
pf_ack_seqnum = ProtoField.new("Sequence Number", "enet_proto.acknowledge.seqnum", ftypes.UINT16)
pf_ack_recvtime = ProtoField.new("Received Time", "enet_proto.acknowledge.recvtime", ftypes.UINT16)

pf_conn = ProtoField.new("Connect", "enet_proto.connect", ftypes.BYTES, nil, base.NONE)
pf_verify_conn = ProtoField.new("Verify Connect", "enet_proto.verify_connect", ftypes.BYTES, nil, base.NONE)
pf_conn_peerid = ProtoField.new("Outgoing Peer Id", "enet_proto.connect.peerid", ftypes.UINT16)
pf_conn_mtu = ProtoField.new("MTU", "enet_proto.connect.mtu", ftypes.UINT16)
pf_conn_window_size = ProtoField.new("Window Size", "enet_proto.connect.window_size", ftypes.UINT32)
pf_conn_channels = ProtoField.new("Channel Count", "enet_proto.connect.channels", ftypes.UINT32)
pf_conn_session_id = ProtoField.new("Session Id", "enet_proto.connect.session_id", ftypes.UINT32)

pf_dc = ProtoField.new("Disconnect", "enet_proto.disconnect", ftypes.BYTES, nil, base.NONE)
pf_dc_data = ProtoField.new("Ping", "enet_proto.disconnect.data", ftypes.UINT32)

pf_ping = ProtoField.new("Ping", "enet_proto.ping", ftypes.BYTES, nil, base.NONE)

pf_reliable = ProtoField.new("Send Reliable", "enet_proto.reliable", ftypes.BYTES, nil, base.NONE)
pf_unreliable = ProtoField.new("Send Unreliable", "enet_proto.unreliable", ftypes.BYTES, nil, base.NONE)
pf_fragment = ProtoField.new("Send Fragment", "enet_proto.fragment", ftypes.BYTES, nil, base.NONE)
pf_unsequenced = ProtoField.new("Send Unsequenced", "enet_proto.unsequenced", ftypes.BYTES, nil, base.NONE)
pf_payload_length = ProtoField.new("Payload Length", "enet_proto.payload.length", ftypes.UINT16)
pf_payload = ProtoField.new("Payload", "enet_proto.payload", ftypes.BYTES, nil, base.NONE)
pf_unreliable_seqnum = ProtoField.new("Unreliable Sequence Number", "enet_proto.unreliable.seqnum", ftypes.UINT16)

pf_fragment_startseqnum = ProtoField.new("Fragment Start Number", "enet_proto.fragment.startseqnum", ftypes.UINT16)
pf_fragment_fragcount = ProtoField.new("Fragment Count", "enet_proto.fragment.count", ftypes.UINT32)
pf_fragment_fragnum = ProtoField.new("Fragment Number", "enet_proto.fragment.num", ftypes.UINT32)
pf_fragment_total_length = ProtoField.new("Total Length", "enet_proto.fragment.length", ftypes.UINT32)
pf_fragment_offset = ProtoField.new("Offset", "enet_proto.fragment.offset", ftypes.UINT32)

pf_unsequenced_group = ProtoField.new("Unsequenced Group", "enet_proto.unsequenced.group", ftypes.UINT16)

pf_bandwidth_limit = ProtoField.new("Bandwidth Limit", "enet_proto.bandwidth_limit", ftypes.BYTES, nil, base.NONE)
pf_bandwidth_incoming_bandwidth = ProtoField.new("Incoming Bandwidth", "enet_proto.bandwidth_limit.incoming_bandwidth", ftypes.UINT32)
pf_bandwidth_outgoing_bandwidth = ProtoField.new("Outgoing Bandwidth", "enet_proto.bandwidth_limit.outgoing_bandwidth", ftypes.UINT32)

pf_packet_throttle = ProtoField.new("Packet Throttle", "enet_proto.packet_throttle", ftypes.BYTES, nil, base.NONE)
pf_throttle_throttle_interval = ProtoField.new("Packet Throttle Interval", "enet_proto.connect.throttle_interval", ftypes.UINT32)
pf_throttle_throttle_accel = ProtoField.new("Packet Throttle Acceleration", "enet_proto.connect.throttle_accel", ftypes.UINT32)
pf_throttle_throttle_decel = ProtoField.new("Packet Throttle Deceleration", "enet_proto.connect.throttle_decel", ftypes.UINT32)


enet_proto.fields = {
	pf_checksum,
	pf_flag_has_sent_time,
	pf_peer_id,
	pf_sent_time,
	pf_seqnumber,
	pf_command,
	pf_channel,
	pf_proto_header,
	pf_header,
	pf_data_length,
	pf_data,
	pf_data_decrypted,
	pf_key,

	pf_ack,
	pf_ack_seqnum,
	pf_ack_recvtime,

	pf_conn,
	pf_verify_conn,
	pf_conn_peerid,
	pf_conn_mtu,
	pf_conn_window_size,
	pf_conn_channels,
	pf_bandwidth_incoming_bandwidth,
	pf_bandwidth_outgoing_bandwidth,
	pf_throttle_throttle_interval,
	pf_throttle_throttle_accel,
	pf_throttle_throttle_decel,
	pf_conn_session_id,

	pf_dc,
	pf_dc_data,

	pf_ping,

	pf_reliable,
	pf_unreliable,
	pf_fragment,
	pf_unsequenced,

	pf_payload_length,
	pf_payload,

	pf_unreliable_seqnum,

	pf_fragment_startseqnum,
	pf_fragment_fragcount,
	pf_fragment_fragnum,
	pf_fragment_total_length,
	pf_fragment_offset,

	pf_packet_throttle,
	pf_bandwidth_limit,

	pf_unsequenced_group
}

lolcmds = {
	[0x00] = "KeyCheck",
	[0x08] = "HeartBeat",
	[0x09] = "C2S_SellItem",
	[0x0b] = "RemoveItem",
	[0x0c] = "S2C_NextAutoAttack",
	[0x0f] = "EPKT_S2C_OnAttack",
	
	[0x11] = "S2C_EndSpawn",
	[0x14] = "C2S_QueryStatusReq",
	[0x15] = "S2C_SkillUp",
	[0x16] = "C2S_Ping_Load_Info",
	[0x17] = "S2C_ChampionDeathTimer",
	[0x1A] = "S2C_AutoAttack",
	[0x1C] = "S2C_EditBuff",


	
	[0x20] = "C2S_SwapItems",
	[0x22] = "S2C_AddGold",
	[0x23] = "S2C_FogUpdate2",
	[0x26] = "S2C_NPC_Die",
	[0x2A] = "S2C_PlayerInfo",
	[0x2C] = "S2C_ViewAns",
	[0x2E] = "C2S_ViewReq",
	[0x2F] = "S2C_ChampionRespawn",
	
	
	[0x34] = "S2C_StopAutoAttack",
	[0x35] = "S2C_DeleteObject",
	[0x39] = "C2S_SkillUp",
	[0x3B] = "S2C_SpawnProjectile",
	[0x3E] = "S2C_SwapItems",
	[0x3F] = "S2C_LevelUp",
	
	[0x40] = "S2C_AttentionPing",
	[0x42] = "S2C_Emotion",
	[0x45] = "S2C_Announce",
	[0x47] = "C2S_AutoAttackOption",
	[0x48] = "C2S_Emotion",
	[0x4C] = "S2C_HeroSpawn",
	[0x4D] = "S2C_Announce",
	
	[0x50] = "S2C_FaceDirection",
	[0x51] = "S2C_LeaveVision",
	[0x52] = "C2S_StartGame",
	[0x54] = "S2C_SynchVersion",
	[0x56] = "C2S_ScoreBord",
	[0x57] = "C2S_AttentionPing",
	[0x5A] = "S2C_DestroyProjectile",
	[0x5C] = "C2S_StartGame",
	[0x5E] = "S2C_ChampionDie",
	
	[0x61] = "S2C_MoveAns",
	[0x62] = "S2C_StartSpawn",
	[0x64] = "C2S_ClientReady | S2C_Dash",
	[0x65] = "S2C_LoadHero",
	[0x66] = "S2C_LoadName",
	[0x67] = "S2C_LoadScreenInfo",
	[0x68] = "ChatBoxMessage",
	[0x6A] = "S2C_SetTarget",
	[0x6B] = "S2C_SetAnimation",
	[0x6E] = "S2C_ShowProjectile",
	[0x6F] = "S2C_BuyItemAns",
	
	[0x72] = "C2S_MoveReq",
	[0x77] = "C2S_MoveConfirm",
	[0x7B] = "S2C_RemoveBuff",
	
	[0x81] = "C2S_LockCamera",
	[0x82] = "C2S_BuyItemReq",
	[0x85] = "S2C_SetCooldown",
	[0x87] = "S2C_SpawnParticle",
	[0x88] = "S2C_QueryStatusAns",
	[0x8F] = "C2S_Exit",
	
	[0x92] = "SendGameNumber",
	[0x95] = "S2C_Ping_Load_Info",
	[0x9A] = "C2S_CastSpell",
	[0x9D] = "S2C_TurretSpawn",
	[0x9E] = "S2C_NPCHide",
	
	[0xA4] = "C2S_Surrender",
	[0xA8] = "C2S_StatsConfirm",
	[0xAE] = "S2C_SetHealth",
	[0xAF] = "C2S_Click",
	
	[0xB0] = "S2C_SpellAnimation",
	[0xB5] = "S2C_CastSpellAns",
	[0xBA] = "S2C_ObjectSpawn",
	[0xBD] = "C2S_SynchVersion",
	[0xBE] = "C2S_CharLoaded",
	
	--[0xC0] = "S2C_GameTimer",
	[0xC0] = "S2C_SetTarget2 (?)",
	[0xC1] = "S2C_GameTimer",
	[0xC2] = "S2C_GameTimerUpdate",
	[0xC4] = "S2C_CharStats",
	
	[0xD0] = "S2C_LevelPropSpawn",
	
	[0xF7] = "S2C_DebugMessage",
	[0xFE] = "S2C_Extended",
	
	[0xFF] = "Batch"
}

--[[
	the core dissector:
	tvbuf -> Tvb object
	pktinfo -> Pinfo object
	root -> TreeItem object 
--]]
function enet_proto.dissector(tvbuf, pktinfo, root)

	pktinfo.cols.protocol = "ENET"
	
	pktlen = tvbuf:reported_length_remaining()
	
	tree = root:add(enet_proto, tvbuf:range(0,pktlen))
	
	-- proto header

	-- Seems like sent_time is always included?
	--[[
	has_sent_time = tvbuf:range(4, 1):bitfield(0, 1) == 1
	if has_sent_time then
		header_length = 8
	else
		header_length = 6
	end
	]]--

	header_length = 8
	pheader = tvbuf:range(0, header_length)
	pheader_buf = pheader:tvb()
	proto_header = tree:add(pf_proto_header, pheader)
	
	proto_header:add(pf_checksum, pheader_buf:range(0, 4))
	--proto_header:add(pf_flag_has_sent_time, pheader_buf:range(4,1), has_sent_time)
	proto_header:add(pf_peer_id, pheader_buf:range(4,2))
	--if has_sent_time then
		proto_header:add(pf_sent_time, pheader_buf:range(6, 2))
	--end

	-- command header
	tvbuf = tvbuf:range(header_length):tvb()
	header = tree:add(pf_header, tvbuf:range(0, 4))

	command = tvbuf:range(0,1):bitfield(4,4)
	if command >= 0 and command <= 11 then
		header:add(pf_command, tvbuf:range(0,1))
	else
		print("unknown command")
		command = 99
	end

	channel = tvbuf:range(1, 1)
	header:add(pf_channel, channel)

	seqnumber = tvbuf:range(2,2)
	header:add(pf_seqnumber, seqnumber)
	
	pktinfo.cols.info = command2string[command]

	
	-- command-based parsing
	tvbuf = tvbuf:range(4):tvb()

	if command == 1 then
		parse_acknowledge(tvbuf, tree)
	elseif command == 2 then
		parse_connect(tvbuf, tree)
	elseif command == 3 then
		parse_verify_connect(tvbuf, tree)
	elseif command == 4 then
		parse_disconnect(tvbuf, tree)
	elseif command == 5 then
		parse_ping(tvbuf, tree)
	elseif command == 6 then
		parse_reliable(tvbuf, tree, pktinfo)
	elseif command == 7 then
		parse_unreliable(tvbuf, tree, pktinfo)
	elseif command == 8 then
		parse_fragment(tvbuf, tree, pktinfo)
	elseif command == 9 then
		parse_unsequenced(tvbuf, tree, pktinfo)
	elseif command == 10 then
		parse_bandwidth_limit(tvbuf, tree)
	elseif command == 11 then
		parse_packet_throttle(tvbuf, tree)
	end

	--[[
	if command == 6 then
	
		loltree = root:add(pf_data, tvbuf:range(10, pktlen - 10))
		loltree:set_text("LoL Data")
		
		if b64key == "" then
			loltree:add(pf_key, "No key found" .. " (" .. b64keyfile .. ")")
			return
		end
		
		loltree:add(pf_key, b64key .. " (" .. b64keyfile .. ")")
	
		coverage = 10
		
		while coverage < pktlen do
		
			data_length = tvbuf:range(coverage-2,2)
			loltree:add(pf_data_length, data_length)
			
			data = tvbuf:range(coverage, data_length:uint())
			
			data_tmp = {}
			
			for i=0, data_length:uint()-1 do
				data_tmp[i] = tvbuf:range(coverage+i, 1):uint()
			end
			
			decryptedData = bf_Decrypt(data_tmp, data_length:uint())
			
			decryptedByteArray = ByteArray.new()
			decryptedHexString = ""
			decryptedByteArray:set_size(data_length:uint())
			for i=0, data_length:uint()-1 do
				decryptedByteArray:set_index(i, decryptedData[i])
				decryptedHexString = decryptedHexString .. string.format("%x ", decryptedData[i])
			end
			
			lolcmd = decryptedByteArray:get_index(0)
			if lolcmds[lolcmd] ~= nil then
				pktinfo.cols.info:append(" " .. lolcmds[lolcmd])
			end
			
			loltree:add(pf_data_decrypted, tvbuf:range(coverage, data_length:uint()), decryptedHexString)
			
			coverage = coverage + data_length:uint()
			
			if coverage < pktlen and 
			( tvbuf:range(coverage, 1):uint() == 0x07 or tvbuf:range(coverage, 1):uint() == 0x49 ) then
				coverage = coverage + 8
			else
				coverage = coverage + 6
			end
			
		end
		
	end
	--]]
end

function decode_payload(tvrange, tree, pktinfo)
	tvbuf = tvrange:tvb()

	loltree = tree:add(pf_data, tvrange)
	loltree:set_text("Decrypted Payload")
	
	if b64key == "" then
		loltree:add(pf_key, "No key found" .. " (" .. b64keyfile .. ")")
		return
	end
	
	loltree:add(pf_key, b64key .. " (" .. b64keyfile .. ")")

	coverage = 0
	
	--while coverage < pktlen do
	
		data_length = tvbuf:len()
		loltree:add(pf_data_length, data_length)
		
		data_tmp = {}
		
		for i=0, data_length-1 do
			data_tmp[i] = tvbuf:range(i, 1):uint()
		end
		
		decryptedData = bf_Decrypt(data_tmp, data_length)
		
		decryptedHexString = ""
		decryptedByteArray = ByteArray.new()
		decryptedByteArray:set_size(data_length)
		for i=0, data_length-1 do
			decryptedByteArray:set_index(i, decryptedData[i])
			decryptedHexString = decryptedHexString .. string.format("%x ", decryptedData[i])
		end
		
		lolcmd = decryptedByteArray:get_index(0)
		if lolcmds[lolcmd] ~= nil then
			pktinfo.cols.info:append(" " .. lolcmds[lolcmd])
		end
		
		loltree:add(pf_payload, tvrange)
		-- Wireshark crashes for tvbufs where the source is not a child of the original tvbuf
		loltree:add(pf_data_decrypted, decryptedByteArray:tvb():range(0))
		
		--[[ No longer needed
		coverage = coverage + data_length
		
		if coverage < pktlen and 
		( tvbuf:range(coverage, 1):uint() == 0x07 or tvbuf:range(coverage, 1):uint() == 0x49 ) then
			coverage = coverage + 8
		else
			coverage = coverage + 6
		end
		]]--
		
	--end
end

function parse_acknowledge(tvbuf, tree)
	ack_buf = tvbuf:range(0, 4)
	ack = tree:add(pf_ack, ack_buf)

	ack:add(pf_ack_seqnum, tvbuf:range(0, 2))
	ack:add(pf_ack_recvtime, tvbuf:range(2, 2))
end

function parse_connect(tvbuf, tree)
	conn_buf = tvbuf:range(0, 36)
	conn = tree:add(pf_conn, conn_buf)

	conn:add(pf_conn_peerid, tvbuf:range(0, 2))
	conn:add(pf_conn_mtu, tvbuf:range(2, 2))
	conn:add(pf_conn_window_size, tvbuf:range(4, 4))
	conn:add(pf_conn_channels, tvbuf:range(8, 4))
	conn:add(pf_bandwidth_incoming_bandwidth, tvbuf:range(12, 4))
	conn:add(pf_bandwidth_outgoing_bandwidth, tvbuf:range(16, 4))
	conn:add(pf_throttle_throttle_interval, tvbuf:range(20, 4))
	conn:add(pf_throttle_throttle_accel, tvbuf:range(24, 4))
	conn:add(pf_throttle_throttle_decel, tvbuf:range(28, 4))
	conn:add(pf_conn_session_id, tvbuf:range(32, 4))
end

function parse_verify_connect(tvbuf, tree)
	conn_buf = tvbuf:range(0, 32)
	conn = tree:add(pf_verify_conn, conn_buf)

	conn:add(pf_conn_peerid, tvbuf:range(0, 2))
	conn:add(pf_conn_mtu, tvbuf:range(2, 2))
	conn:add(pf_conn_window_size, tvbuf:range(4, 4))
	conn:add(pf_conn_channels, tvbuf:range(8, 4))
	conn:add(pf_bandwidth_incoming_bandwidth, tvbuf:range(12, 4))
	conn:add(pf_bandwidth_outgoing_bandwidth, tvbuf:range(16, 4))
	conn:add(pf_throttle_throttle_interval, tvbuf:range(20, 4))
	conn:add(pf_throttle_throttle_accel, tvbuf:range(24, 4))
	conn:add(pf_throttle_throttle_decel, tvbuf:range(28, 4))
end

function parse_disconnect(tvbuf, tree)
	dc_buf = tvbuf:range(0, 4)
	dc = tree:add(pf_dc, dc_buf)

	dc:add(pf_dc_data, tvbuf:range(0, 4))
end

function parse_ping(tvbuf, tree)
	ping_buf = tvbuf:range(0)
	ping = tree:add(pf_ping, ping_buf)
end

function parse_reliable(tvbuf, tree, pktinfo)
	buf = tvbuf:range(0)
	reliable = tree:add(pf_reliable, buf)

	reliable:add(pf_payload_length, tvbuf:range(0, 2))
	decode_payload(tvbuf:range(2), reliable, pktinfo)
end

function parse_unreliable(tvbuf, tree, pktinfo)
	buf = tvbuf:range(0)
	unreliable = tree:add(pf_unreliable, buf)

	unreliable:add(pf_unreliable_seqnum, tvbuf:range(0, 2))
	unreliable:add(pf_payload_length, tvbuf:range(2, 2))
	decode_payload(tvbuf:range(4), unreliable, pktinfo)
end

function parse_fragment(tvbuf, tree, pktinfo)
	buf = tvbuf:range(0)
	fragment = tree:add(pf_fragment, buf)

	fragment:add(pf_fragment_startseqnum, tvbuf:range(0, 2))
	fragment:add(pf_payload_length, tvbuf:range(2, 2))
	fragment:add(pf_fragment_fragcount, tvbuf:range(4, 4))
	fragment:add(pf_fragment_fragnum, tvbuf:range(8, 4))
	fragment:add(pf_fragment_total_length, tvbuf:range(12, 4))
	fragment:add(pf_fragment_offset, tvbuf:range(16, 4))
	fragment:add(pf_payload, tvbuf:range(20))
end

function parse_unsequenced(tvbuf, tree, pktinfo)
	buf = tvbuf:range(0)
	unsequenced = tree:add(pf_unsequenced, buf)

	unsequenced:add(pf_unsequenced_group, tvbuf:range(0, 2))
	unsequenced:add(pf_payload_length, tvbuf:range(2, 2))
	unsequenced:add(pf_payload, tvbuf:range(4))
end

function parse_bandwidth_limit(tvbuf, tree)
	buf = tvbuf:range(0)
	limit = tree:add(pf_bandwidth_limit)

	limit:add(pf_bandwidth_incoming_bandwidth, tvbuf:range(0, 4))
	limit:add(pf_bandwidth_outgoing_bandwidth, tvbuf:range(4, 4))
end

function parse_packet_throttle(tvbuf, tree)
	buf = tvbuf:range(0)
	throttle = tree:add(pf_packet_throttle)

	throttle:add(pf_throttle_throttle_interval, tvbuf:range(0, 4))
	throttle:add(pf_throttle_throttle_accel, tvbuf:range(4, 4))
	throttle:add(pf_throttle_throttle_decel, tvbuf:range(8, 4))
end



-- load the udp.port table
-- udp_table = DissectorTable.get("udp.port")

-- register our protocol to handle one specific udp port
-- udp_table:add(5100, enet_proto)

--[[
	a heuristic to decide if the ENET dissector should handle the data
	sadly its broken, u cannot return true here (wireshark.exe crashes, tshark.exe is doing fine!)
	but if you set the enet protocol for the rest of the conversation and return false,
	somehow it works as intended
--]]
function heur_dissect_enet(tvbuf, pktinfo, root)
	print("heur_dissect_enet")
	
	tvbr = tvbuf:range(0,1)
	if tvbr:uint() == 41 then
		print("found the first byte to be 0x29 (dec: 41), its ENET")
	else
		if pktinfo.src_port > MIN_PORT and pktinfo.src_port < MAX_PORT then

		else
			if pktinfo.dst_port > MIN_PORT and pktinfo.dst_port < MAX_PORT then

			else
				return false
			end
		end
	end
	
	-- generate a filename/identifier for this capture
	-- wireshark doesnt provide the .pcap filename in LUA (why?)
	-- one cannot add data to the capture file
	-- only other approach would be using Prefs :/
	
	-- data for id: absolute time of capture, server port, server adress
	
	--print(pktinfo.abs_ts)
	--print(pktinfo.src)
	--print(pktinfo.dst)
	
	id_port = 0
	if pktinfo.src_port > MIN_PORT and pktinfo.src_port < MAX_PORT then
		id_port = pktinfo.src_port
	end
	if pktinfo.dst_port > MIN_PORT and pktinfo.dst_port < MAX_PORT then
		id_port = pktinfo.dst_port
	end
	print("id_port ".. id_port)
	
	
	-- YYYY_MM_DD-hh_mm
	id_date = os.date("%Y_%m_%d-%H_%M", math.floor(pktinfo.abs_ts))
	print("id_date" .. id_date)
	
	filename = USER_DIR .. "plugins\\lolkeys\\" .. id_date .. "-" .. id_port .. ".txt"
	
	b64key = ""
	b64keyfile = ""
	content = ""
	file = io.open(filename, "r")
	if file~=nil then
		content = file:read("*all")
		print("Content: " .. content)
		io.close(file)
		b64keyfile = filename
	else
		print("error opening file ".. filename)
		file = io.open(filename, "w")
		if file~=nil then
			file:write("")
			io.close(file)
			b64keyfile = filename
		else
			print("error creating file ".. filename)
			b64keyfile = "Error, could not create " .. filename
		end
	end
	
	if string.len(content) == 24 and string.match(content, "[a-zA-Z0-9%+/]+==") ~= nil then
		print("Valid Key found")
		b64key = content
		b64keyfile = filename
	else
		cmdstring = "cscript.exe /nologo " .. USER_DIR .. "plugins\\GetLoLGameHash.vbs"
		handle = io.popen(cmdstring , "r")
		output = handle:read('*all')
		handle:close()
		print("Output from " .. cmdstring .. ": " .. output)
		if string.len(output) == 24 and string.match(output, "[a-zA-Z0-9%+/]+==") ~= nil then
			print("Valid Key found")
			b64key = output
			b64keyfile = cmdstring
			file = io.open(filename, "w")
			if file~=nil then
				file:write(output)
				io.close(file)
			else
				print("error creating file ".. filename)
			end
		end
	end
	
	bf_Init(b64key)
	
	enet_proto.dissector(tvbuf, pktinfo, root)
	pktinfo.conversation = enet_proto
	
	return false -- yeah just return always false .....
end

-- register the heuristic for udp only:
enet_proto:register_heuristic("udp", heur_dissect_enet)
