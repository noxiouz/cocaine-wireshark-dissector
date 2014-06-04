mp = require 'MessagePack'

cocaine = Proto ("cocaine_proto", "Cocaine Protocol")
cocaine.fields.command = ProtoField.uint16("cocaine_proto.command", "command")
cocaine.fields.session = ProtoField.uint16("cocaine_proto.session", "session")

function cocaine.dissector (buf, pkt, root)
  if buf:len() == 0 then return end
  unpacked = mp.unpack(buf():string())
  command, session = unpacked[1], unpacked[2]
  -- build info tree
  local t = root:add(cocaine,buf())
  t:add(cocaine.fields.command, command)
  t:add(cocaine.fields.session, session)
end

function cocaine.init()
end

local tcp_dissector_table = DissectorTable.get("tcp.port")
dissector = tcp_dissector_table:get_dissector(10053)
tcp_dissector_table:add(10053, cocaine)
