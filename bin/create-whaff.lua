#! /usr/bin/env lua

-- last modified 2024-04-26

local whaff_file = ...

local function create_test_file(whaff_file)
  local i = io.open('test.arr')
  local o = io.open('test-w.arr', 'w')
  local done = false
  while true do
    local L = i:read()
    if not L then break end
    if not done then
      if L:match('include%s+file%(".-%-code.arr"%)') or L:match('import%s+file%(".-%-code.arr"%)') then
        L = L:gsub('file%("(.-)%-code.arr"%)', 'file("' .. whaff_file .. '")')
        done = true
      end
    end
    if not (L:match('^%s*include%s+cpo') or L:match('^%s*include%s+lists')) then
      o:write(L, '\n')
    end
    -- if not (L:match('^%s*import%s+cpo') or L:match('^%s*include%s+cpo') or L:match('^%s*import%s+lists') or L:match('^%s*include%s+lists')) then
    --   o:write(L, '\n')
    -- end
  end
  o:close()
end

create_test_file(whaff_file)
