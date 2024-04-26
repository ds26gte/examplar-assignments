#! /usr/bin/env lua

-- last modified 2024-04-26

local ifile, ofile = ...

local function localize_whaff_file(ifile, ofile)
  print('doing localize_whaff_file', ifile, ofile)
  local i = io.open(ifile)
  local o = io.open(ofile, 'w')
  while true do
    local L = i:read()
    if not L then break end
    if not (L:match('^%s*import%s+cpo') or L:match('^%s*import%s+lists') or L:match('^%s*include%s+cpo') or L:match('^%s*include%s+lists')) then
      o:write(L, '\n')
    end
  end
  o:close()
end

localize_whaff_file(ifile, ofile)

