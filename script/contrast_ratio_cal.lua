--[[
	contrast_ratio_cal.lua
	Copyright (c) 2022 CaffemochaY

	sourse : [WCAG 2.0](https://www.w3.org/TR/WCAG20-TECHS/G17.html#G17-procedure)
]]

local CRC = {}

local function contrast_ratio_cal(crc_col1, crc_col2)
	local ct = {}
	ct.col1, ct.col2, ct.coltype = {}, {}, {"r", "g", "b"}
	ct.col1.ori, ct.col2.ori = crc_col1, crc_col2

	-- Disassemble RGB & Normalization
	for i = 1, 2 do
		ct["col"..i].rs = math.floor(ct["col"..i].ori / 65536) / 255
		ct["col"..i].gs = math.floor(bit.band(ct["col"..i].ori, 65535) / 256) / 255
		ct["col"..i].bs = math.floor(bit.band(ct["col"..i].ori, 255)) / 255
	end

	-- Calculate luminance of each
	for i = 1, 2 do
		for j = 1, #ct.coltype do
			if ct["col"..i][ct.coltype[j].."s"] <= 0.03928 then
				ct["col"..i][ct.coltype[j].."l"] = ct["col"..i][ct.coltype[j].."s"] / 12.92
			else
				ct["col"..i][ct.coltype[j].."l"] = ((ct["col"..i][ct.coltype[j].."s"] + 0.055) / 1.055) ^ 2.4
			end
		end
		ct["col"..i].l = ct["col"..i].rl * 0.2126 + ct["col"..i].gl * 0.7152 + ct["col"..i].bl * 0.0722
	end

	-- Calculate contrast ratio & When less than 1, convert to reciprocal
	ct.ratio = (ct.col1.l + 0.05) / (ct.col2.l + 0.05)
	if ct.ratio < 1 then ct.ratio = 1 / ct.ratio end

	return ct
end

CRC.contrast_ratio_cal = contrast_ratio_cal

return CRC
