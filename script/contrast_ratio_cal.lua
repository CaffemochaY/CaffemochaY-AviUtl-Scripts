--[[
	contrast_ratio_cal.lua
	Copyright (c) 2022 CaffemochaY

	sourse : [WCAG 2.0](https://www.w3.org/TR/WCAG20-TECHS/G17.html#G17-procedure)
]]

local function contrast_ratio_cal(crc_col1, crc_col2)
	local ct = {{ori = crc_col1}, {ori = crc_col2}, t = {"r", "g", "b"}}

	for i = 1, 2 do
		-- Disassemble RGB & Normalization
		ct[i].rs = math.floor(ct[i].ori / 65536) / 255
		ct[i].gs = math.floor(bit.band(ct[i].ori, 65535) / 256) / 255
		ct[i].bs = math.floor(bit.band(ct[i].ori, 255)) / 255

		-- Calculate luminance of each
		for j = 1, 3 do
			if ct[i][ct.t[j].."s"] <= 0.03928 then
				ct[i][ct.t[j].."l"] = ct[i][ct.t[j].."s"] / 12.92
			else
				ct[i][ct.t[j].."l"] = ((ct[i][ct.t[j].."s"] + 0.055) / 1.055) ^ 2.4
			end
		end
		ct[i].l = ct[i].rl * 0.2126 + ct[i].gl * 0.7152 + ct[i].bl * 0.0722
	end

	-- Calculate contrast ratio & When less than 1, convert to reciprocal
	ct.ratio = (ct[1].l + 0.05) / (ct[2].l + 0.05)
	if ct.ratio < 1 then ct.ratio = 1 / ct.ratio end

	return ct
end

local CRC = {}
CRC.contrast_ratio_cal = contrast_ratio_cal

return CRC
