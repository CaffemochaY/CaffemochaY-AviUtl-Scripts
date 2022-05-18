--[[
	aviutl_effect_list.lua / ver.1.0.1
	Copyright (c) 2022 CaffemochaY

	- parameter
		- _name         : "string"
		- track
			- track0      : "number"
			- track1      : "number"
			- track2      : "number"
			- track3      : "number"
			- track4      : "number"
			- track5      : "number"
			- track6      : "number"
			- track7      : "number"
		- color
			- color1/col  : "number"
			- color2/col  : "number"
		- check
			- check0/chk  : "number"
			- check1/chk  : "number"
			- check2/chk  : "number"
			- check3/chk  : "number"
			- check4/chk  : "number"
		- mode          : "number"
		- etype         : "number"
		- name / file   : "string"
		- color_yc
			- color_yc1   : "table" or "number"
			- color_yc2   : "table" or "number"
		- seed          : "number"
		- calc          : "number"
		- param         : "string"

	- changelog
		- ver.1.0.1
			- バージョン表記を3桁に変更
			- コメントを少し整理
]]

--YCbCrの数値変換
local function ycbcrconvert(ycbcrcol)
	local colycre, ycstatus, colyc = 0, 1, {}
	if type(ycbcrcol) == "table" then
		if ycbcrcol[2] then
			local bit = require("bit")
			for i = 1, 3 do
				if ycbcrcol[i] then
					colyc[i] = bit.tohex(bit.rshift(bit.bswap(ycbcrcol[i]), 16), 4)
				else
					colyc[i] = bit.tohex(0, 4)
				end
			end
			colycre = colyc[1] .. colyc[2] .. colyc[3]
		else
			colycre = ycbcrcol[1]
		end
	elseif type(ycbcrcol) == "number" or "string" then
		colycre = ycbcrcol
	else
		ycstatus = 0
	end
	return colycre, ycstatus
end

--nameの整形
local function nameformat(name)
	local nfe
	if not name then
		nfe = nil
	elseif name == "*tempbuffer" or "tempbuffer" or "仮想バッファ" then
		nfe = "*tempbuffer"
	elseif string.sub(name, 1, 5) == "scene" then
		nfe = ":"..string.sub(name, 6)
	elseif string.sub(name, 1, 1) == ":" then
		nfe = name
	elseif string.sub(name, 2, 3) == ":\\" then
		nfe = "*"..name
	elseif string.sub(name, 1, 1) == "*" and string.sub(name, 3, 4) == ":\\" then
		nfe = name
	else
		nfe = nil
	end
	return nfe
end

--------------------------------------------------

--色調補正
local function colorcorrection(track0, track1, track2, track3, track4, check0)
	obj.effect("色調補正", "明るさ", track0, "ｺﾝﾄﾗｽﾄ", track1, "色相", track2, "輝度", track3, "彩度", track4, "飽和する", check0)
end

--クリッピング
local function clipping(track0, track1, track2, track3, check0)
	obj.effect("クリッピング", "上", track0 "下", track1 "左", track2 "右", track3 "中心の位置を変更", check0)
end

--ぼかし
local function shadingoff(track0, track1, track2, check0)
	if track0 ~= 0 then obj.effect("ぼかし", "範囲", track0, "縦横比", track1, "光の強さ", track2, "サイズ固定", check0) end
end

--境界ぼかし
local function bordershadingoff(track0, track1, check0)
	if track0 ~= 0 then obj.effect("境界ぼかし", "範囲", track0, "縦横比", track1, "透明度の境界をぼかす", check0) end
end

--モザイク
local function mosaic(track0, check0)
	if track0 ~= 0 then obj.effect("モザイク", "サイズ", track0, "タイル風", check0) end
end

--発光
local function luminescence(track0, track1, track2, track3, check0, color1)
	if track0 ~= 0 then
		local nocol1 = 0
		if not color1 then color1, nocol1 = 0x0, 1 end
		obj.effect("発光", "強さ", track0, "拡散", track1, "しきい値", track2, "拡散速度", track3, "サイズ固定", check0, "color", color1, "no_color", nocol1)
	end
end

--閃光
local function flash(track0, track1, track2, check0, color1, mode)
	if track0 ~= 0 then
		local nocol1 = 0
		if not color1 then color1, nocol1 = 0x0, 1 end
		obj.effect("閃光", "強さ", track0, "X", track1, "Y", track2, "サイズ固定", check0, "color", color1, "no_color", nocol1, "mode", mode)
	end
end

--拡散光
local function diffuselight(track0, track1, check0)
	if track0 ~= 0 then obj.effect("拡散光", "強さ", track0, "拡散", track1, "サイズ固定", check0) end
end

--グロー
local function glow(track0, track1, track2, track3, check0, color1, etype)
	local nocol1 = 0
	if not color1 then color1, nocol1 = 0x0, 1 end
	if track0 ~= 0 then obj.effect("グロー", "強さ", track0, "拡散", track1, "しきい値", track2, "ぼかし", track3, "光成分のみ", check0, "color", color1, "no_color", nocol1, "type", etype) end
end

--クロマキー
local function chromakey(track0, track1, track2, check0, check1, color_yc1)
	local colycre1, ycstatus1 = ycbcrconvert(color_yc1)
	obj.effect("クロマキー", "色相範囲", track0, "彩度範囲", track1, "境界補正", track2, "色彩補正", check0, "透過補正", check1, "color_yc", colycre1, "status", ycstatus1)
end

--カラーキー
local function colorkey(track0, track1, track2, color_yc1)
	local colycre1, ycstatus1 = ycbcrconvert(color_yc1)
	obj.effect("カラーキー", "輝度範囲", track0, "色差範囲", track1, "境界補正", track2, "color_yc", colycre1, "status", ycstatus1)
end

--ルミナンスキー
local function luminancekey(track0, track1, etype)
	obj.effect("ルミナンスキー", "基準輝度", track0 "ぼかし", track1 "type", etype)
end

--ライト
local function light(track0, track1, track2, check0, color1)
	if track0 ~= 0 then obj.effect("ライト", "強さ", track0, "拡散", track1, "比率", track2, "逆光", check0, "color", color1) end
end

--シャドー
local function shadow(track0, track1, track2, track3, check0, color1, name)
	if track2 ~= 0 then obj.effect("シャドー", "X", track0, "Y", track1, "濃さ", track2, "拡散", track3, "影を別オブジェクトで描画", check0, "color", color1, "file", name) end
end

--縁取り
local function bordering(track0, track1, color1, name)
	if track0 ~= 0 then obj.effect("縁取り", "サイズ", track0, "ぼかし", track1, "color", color1, "file", name) end
end

--凸エッジ
local function convexedge(track0, track1, track2)
	if track0 ~= 0 then obj.effect("凸エッジ", "幅", track0, "高さ", track1, "角度", track2) end
end

--エッジ抽出
local function edgeextraction(track0, track1, check0, check1, color1)
	if track0 ~= 0 then obj.effect("エッジ抽出", "強さ", track0, "しきい値", track1, "輝度エッジを抽出", check0, "透明度エッジを抽出", check1, "color", color1) end
end

--シャープ
local function sharp(track0, track1)
	if track0 ~= 0 then obj.effect("シャープ", "強さ", track0, "範囲", track1) end
end

--フェード
local function fade(track0, track1)
	obj.effect("フェード", "イン", track0, "アウト", track1)
end

--ワイプ
local function wipe(track0, track1, track2, check0, check1, etype, name)
	obj.effect("ワイプ", "イン", track0, "アウト", track1, "ぼかし", track2, "反転(イン)", check0, "反転(アウト)", check1, "type", etype, "name", name)
end

--マスク
	--エフェクトのマスクでシーンを一度指定しないとobj.effectのマスクでシーンが読めていないっぽいので注意
local function mask(track0, track1, track2, track3, track4, track5, check0, check1, etype, name, mode)
	local nfe = nameformat(name)
	obj.effect("マスク", "X", track0, "Y", track1, "回転", track2, "サイズ", track3, "縦横比", track4, "ぼかし", track5, "マスクの反転", check0, "元のサイズに合わせる", check1, "type", etype, "name", nfe, "mode", mode)
end

--斜めクリッピング
local function obliqueclip(track0, track1, track2, track3, track4)
	obj.effect("斜めクリッピング", "中心X", track0, "中心Y", track1, "角度", track2, "ぼかし", track3, "幅", track4)
end

--放射ブラー
local function radiationblur(track0, track1, track2, check0)
	if track0 ~= 0 then obj.effect("放射ブラー", "範囲", track0, "X", track1, "Y", track2, "サイズ固定", check0) end
end

--方向ブラー
local function directionblur(track0, track1, check0)
	if track0 ~= 0 then obj.effect("方向ブラー", "範囲", track0, "角度", track1, "サイズ固定", check0) end
end

--レンズブラー
local function lensblur(track0, track1, check0)
	if track0 ~= 0 then obj.effect("レンズブラー", "範囲", track0, "光の強さ", track1, "サイズ固定", check0) end
end

--モーションブラー
	--動かない？ / オフスクリーン描画を1にすると最初と最後のフレームのみが見える
--[[
local function motionblur(track0, track1, check0, check1, check2)
	obj.effect("モーションブラー", "間隔", track0, "分解能", track1, "残像", check0, "オフスクリーン描画", check1, "出力時に分解能を上げる", check2)
end
--]]

--座標
local function coordinate(track0, track1, track2)
	obj.effect("座標", "X", track0, "Y", track1, "Z", track2)
end

--拡大率
local function zoomrate(track0, track1, track2)
	obj.effect("座標", "拡大率", track0, "X", track1, "Y", track2)
end

--透明度
local function transparency(track0)
	obj.effect("座標", "透明度", track0)
end

--回転
local function turning(track0, track1, track2)
	obj.effect("回転", "X", track0, "Y", track1, "Z", track2)
end

--領域拡張
local function areaextension(track0, track1, track2, track3 ,check0)
	obj.effect("領域拡張", "上", track0, "下", track1, "左", track2, "右", track3, "塗りつぶし", check0)
end

--リサイズ
local function resize(track0, track1, track2, check0, check1)
	obj.effect("リサイズ", "拡大率", track0, "X", track1, "Y", track2, "補間なし", check0, "ドット数でサイズ指定", check1)
end

--ローテーション
local function rotation(track0)
	obj.effect("ローテーション", "90度回転", track0)
end

--反転
local function inversion(check0, check1, check2, check3, check4)
	obj.effect("反転", "上下反転", check0, "左右反転", check1, "輝度反転", check2, "色相反転", check3, "透明度反転", check4)
end

--振動
local function vibration(track0, track1, track2, track3, check0, check1)
	obj.effect("振動", "X", track0, "Y", track1, "Z", track2, "周期", track3, "ランダムに強さを変える", check0, "複雑に振動", check1)
end

--ミラー
local function mirror(track0, track1, track2, check0, etype)
	obj.effect("ミラー", "透明度", track0, "減衰", track1, "境目調整", track2, "中心の位置を変更", check0, "type", etype)
end

--ラスター
local function raster(track0, track1, track2, check0, check1)
	obj.effect("ラスター", "横幅", track0, "高さ", track1, "周期", track2, "縦ラスター", check0, "ランダム振幅", check1)
end

--画像ループ
local function imageloop(track0, track1, track2, track3, check0)
	obj.effect("画像ループ", "横回数", track0, "縦回数", track1, "速度X", track2, "速度Y", track3, "個別オブジェクト", check0)
end

--極座標変換
local function polarcoordconv(track0, track1, track2, track3)
	obj.effect("極座標変換", "中心幅", track0, "拡大率", track1, "回転", track2, "渦巻", track3)
end

--ディスプレイスメントマップ
	--エフェクトのディスプレイスメントマップでシーンを一度指定しないとobj.effectのマスクでシーンが読めていないっぽいので注意
local function displacementmap(track0, track1, track2, track3, track4, track5, track6, track7, check0, etype, name, mode, calc)
	local nfe = nameformat(name)
	obj.effect("ディスプレイスメントマップ", "param0", track0, "param1", track1, "X", track2, "Y", track3, "回転", track4, "サイズ", track5, "縦横比", track6, "ぼかし", track7, "元のサイズに合わせる", check0, "type", etype, "name", nfe, "mode", mode, "calc", calc)
end

--ノイズ
local function noise(track0, track1, track2, track3, track4, track5, track6, etype, mode, seed)
	if track0 ~= 0 then obj.effect("ノイズ", "強さ", track0, "速度X", track1, "速度Y", track2, "変化速度", track3, "周期X", track4, "周期Y", track5, "しきい値", track6, "type", etype, "mode", mode, "seed", seed) end
end

--色ずれ
local function colorshift(track0, track1, track2, etype)
	if track0 ~= 0 and track2 ~= 0 then obj.effect("色ずれ", "ずれ幅", track0, "角度", track1, "強さ", track2, "type", etype) end
end

--単色化
local function monochroma(track0, check0, color1)
	if not color1 then color1 = 0x0 end
	obj.effect("単色化", "強さ", track0, "輝度を保持する", check0, "color", color1)
end

--グラデーション
local function gradation(track0, track1, track2, track3, track4, mode, color1, color2 ,etype)
	local nocol1, nocol2 = 0, 0
	if not color1 then color1, nocol1 = 0x0, 1 end
	if not color2 then color2, nocol2 = 0x0, 1 end
	if track0 ~= 0 then obj.effect("グラデーション", "強さ", track0, "中心X", track1, "中心Y", track2, "角度", track3, "幅", track4, "blend", mode, "color", color1, "no_color", nocol1, "color2", color2, "no_color2", nocol2, "type", etype) end
end

--拡張色設定
--[[
local function advancecolset(track0, track1, track2, check0)
	obj.effect("拡張色設定", "R", track0, "G", track1, "B", track2, "RGB⇔HSV", check0)
end
--]]

--特定色域変換
local function specolspaceconv(track0, track1, track2, color_yc1, color_yc2)
	local colycre1, ycstatus1 = ycbcrconvert(color_yc1)
	local colycre2, ycstatus2 = ycbcrconvert(color_yc2)
	obj.effect("特定色域変換", "色相範囲", track0, "彩度範囲", track1, "境界補正", track2, "color_yc", colycre1, "status", ycstatus1, "color_yc2", colycre2, "status2", ycstatus2)
end

--アニメーション効果
local function animationeffect(track0, track1, track2, track3, check0, name, param)
	obj.effect("アニメーション効果", "track0", track0, "track1", track1, "track2", track2, "track3", track3, "check0", check0, "name", name, "param", param)
end

--動画ファイル合成
local function videocomposition(track0, track1, track2, track3, track4, check0, check1, check2, file, mode)
	local nfe = nameformat(file)
	obj.effect("動画ファイル合成", "再生位置", track0, "再生速度", track1, "X", track2, "Y", track3, "拡大率", track4, "ループ再生", check0, "動画ファイルの同期", check1, "ループ画像", check2, "file", nfe, "mode", mode)
end

--画像ファイル合成
local function pictcomposition(track0, track1, track2, check0, mode, file)
	local nfe = nameformat(file)
	obj.effect("動画ファイル合成", "X", track0, "Y", track1, "拡大率", track2, "ループ画像", check0, "file", nfe, "mode", mode, "file", nfe)
end

--インターレース解除
local function deinterlacing(etype)
	obj.effect("ンターレース解除", "type", etype)
end

--カメラ制御オプション
local function camctrloption(check0, check1, check2, check3)
	obj.effect("カメラ制御オプション", "カメラの方を向く", check0, "カメラの方を向く(縦横方向のみ)", check1, "カメラの方を向く(横方向のみ)", check2, "シャドーの対象から外す", check3)
end

--オフスクリーン描画
local function offscreen()
	obj.effect("オフスクリーン描画")
end

--オブジェクト分割
local function objsplit(track0, track1)
	obj.effect("オブジェクト分割", "横分割数", track0, "縦分割数", track1)
end

--------------------------------------------------

--分岐
local function auleffectlist(_name, track0, track1, track2, track3, track4, track5, track6, track7, color1, color2, check0, check1, check2, check3, check4, mode, etype, name, color_yc1, color_yc2, seed, calc, param)
	if _name == "色調補正" then colorcorrection(track0, track1, track2, track3, track4, check0)
	elseif _name == "クリッピング" then clipping(track0, track1, track2, track3, check0)
	elseif _name == "ぼかし" then shadingoff(track0, track1, track2, check0)
	elseif _name == "境界ぼかし" then bordershadingoff(track0, track1, check0)
	elseif _name == "モザイク" then mosaic(track0, check0)
	elseif _name == "発光" then luminescence(track0, track1, track2, track3, check0, color1)
	elseif _name == "閃光" then flash(track0, track1, track2, check0, color1, mode)
	elseif _name == "拡散光" then diffuselight(track0, track1, check0)
	elseif _name == "グロー" then glow(track0, track1, track2, track3, check0, color1, etype)
	elseif _name == "クロマキー" then chromakey(track0, track1, track2, check0, check1, color_yc1)
	elseif _name == "カラーキー" then colorkey(track0, track1, track2, color_yc1)
	elseif _name == "ルミナンスキー" then luminancekey(track0, track1, etype)
	elseif _name == "ライト" then light(track0, track1, track2, check0, color1)
	elseif _name == "シャドー" then shadow(track0, track1, track2, track3, check0, color1, name)
	elseif _name == "縁取り" then bordering(track0, track1, color1, name)
	elseif _name == "凸エッジ" then convexedge(track0, track1, track2)
	elseif _name == "エッジ抽出" then edgeextraction(track0, track1, check0, check1, color1)
	elseif _name == "シャープ" then sharp(track0, track1)
	elseif _name == "フェード" then fade(track0, track1)
	elseif _name == "ワイプ" then wipe(track0, track1, track2, check0, check1, etype, name)
	elseif _name == "マスク" then mask(track0, track1, track2, track3, track4, track5, check0, check1, etype, name, mode)
	elseif _name == "斜めクリッピング" then obliqueclip(track0, track1, track2, track3, track4)
	elseif _name == "放射ブラー" then radiationblur(track0, track1, track2, check0)
	elseif _name == "方向ブラー" then directionblur(track0, track1, check0)
	elseif _name == "レンズブラー" then lensblur(track0, track1, check0)
	-- elseif _name == "モーションブラー" then motionblur(track0, track1, check0, check1, check2)
	elseif _name == "座標" then coordinate(track0, track1, track2)
	elseif _name == "拡大率" then zoomrate(track0, track1, track2)
	elseif _name == "透明度" then transparency(track0)
	elseif _name == "回転" then turning(track0, track1, track2)
	elseif _name == "領域拡張" then areaextension(track0, track1, track2, track3 ,check0)
	elseif _name == "リサイズ" then resize(track0, track1, track2, check0, check1)
	elseif _name == "ローテーション" then rotation(track0)
	elseif _name == "反転" then inversion(check0, check1, check2, check3, check4)
	elseif _name == "振動" then vibration(track0, track1, track2, track3, check0, check1)
	elseif _name == "ミラー" then mirror(track0, track1, track2, check0, etype)
	elseif _name == "ラスター" then raster(track0, track1, track2, check0, check1)
	elseif _name == "画像ループ" then imageloop(track0, track1, track2, track3, check0)
	elseif _name == "極座標変換" then polarcoordconv(track0, track1, track2, track3)
	elseif _name == "ディスプレイスメントマップ" then displacementmap(track0, track1, track2, track3, track4, track5, track6, track7, check0, etype, name, mode, calc)
	elseif _name == "ノイズ" then noise(track0, track1, track2, track3, track4, track5, track6, etype, mode, seed)
	elseif _name == "色ずれ" then colorshift(track0, track1, track2, etype)
	elseif _name == "単色化" then monochroma(track0, check0, color1)
	elseif _name == "グラデーション" then gradation(track0, track1, track2, track3, track4, mode, color1, color2 ,etype)
	-- elseif _name == "拡張色設定" then advancecolset(track0, track1, track2, check0)
	elseif _name == "特定色域変換" then specolspaceconv(track0, track1, track2, color_yc1, color_yc2)
	elseif _name == "アニメーション効果" then animationeffect(track0, track1, track2, track3, check0, name, param)
	elseif _name == "動画ファイル合成" then videocomposition(track0, track1, track2, track3, track4, check0, check1, check2, name, mode)
	elseif _name == "画像ファイル合成" then pictcomposition(track0, track1, track2, check0, mode, name)
	elseif _name == "インターレース解除" then deinterlacing(etype)
	elseif _name == "カメラ制御オプション" then camctrloption(check0, check1, check2, check3)
	elseif _name == "オフスクリーン描画" then offscreen()
	elseif _name == "オブジェクト分割" then objsplit(track0, track1)
	end
end

--関数代入
local AULEL = {}
AULEL.colorcorrection = colorcorrection   -- 色調補正
AULEL.clipping = clipping                 -- クリッピング
AULEL.shadingoff = shadingoff             -- ぼかし
AULEL.bordershadingoff = bordershadingoff -- 境界ぼかし
AULEL.mosaic = mosaic                     -- モザイク
AULEL.luminescence = luminescence         -- 発光
AULEL.flash = flash                       -- 閃光
AULEL.diffuselight = diffuselight         -- 拡散光
AULEL.glow = glow                         -- グロー
AULEL.chromakey = chromakey               -- クロマキー
AULEL.colorkey = colorkey                 -- カラーキー
AULEL.luminancekey = luminancekey         -- ルミナンスキー
AULEL.light = light                       -- ライト
AULEL.shadow = shadow                     -- シャドー
AULEL.bordering = bordering               -- 縁取り
AULEL.convexedge = convexedge             -- 凸エッジ
AULEL.edgeextraction = edgeextraction     -- エッジ抽出
AULEL.sharp = sharp                       -- シャープ
AULEL.fade = fade                         -- フェード
AULEL.wipe = wipe                         -- ワイプ
AULEL.mask = mask                         -- マスク
AULEL.obliqueclip = obliqueclip           -- 斜めクリッピング
AULEL.radiationblur = radiationblur       -- 放射ブラー
AULEL.directionblur = directionblur       -- 方向ブラー
AULEL.lensblur = lensblur                 -- レンズブラー
-- AULEL.motionblur = motionblur             -- モーションブラー
AULEL.coordinate = coordinate             -- 座標
AULEL.zoomrate = zoomrate                 -- 拡大率
AULEL.transparency = transparency         -- 透明度
AULEL.turning = turning                   -- 回転
AULEL.areaextension = areaextension       -- 領域拡張
AULEL.resize = resize                     -- リサイズ
AULEL.rotation = rotation                 -- ローテーション
AULEL.inversion = inversion               -- 反転
AULEL.vibration = vibration               -- 振動
AULEL.mirror = mirror                     -- ミラー
AULEL.raster = raster                     -- ラスター
AULEL.imageloop = imageloop               -- 画像ループ
AULEL.polarcoordconv = polarcoordconv     -- 極座標変換
AULEL.displacementmap = displacementmap   -- ディスプレイスメントマップ
AULEL.noise = noise                       -- ノイズ
AULEL.colorshift = colorshift             -- 色ずれ
AULEL.monochroma = monochroma             -- 単色化
AULEL.gradation = gradation               -- グラデーション
-- AULEL.advancecolset = advancecolset       -- 拡張色設定
AULEL.specolspaceconv = specolspaceconv   -- 特定色域変換
AULEL.animationeffect = animationeffect   -- アニメーション効果
AULEL.videocomposition = videocomposition -- 動画ファイル合成
AULEL.pictcomposition = pictcomposition   -- 画像ファイル合成
AULEL.deinterlacing = deinterlacing       -- インターレース解除
AULEL.camctrloption = camctrloption       -- カメラ制御オプション
AULEL.offscreen = offscreen               -- オフスクリーン描画
AULEL.objsplit = objsplit                 -- オブジェクト分割
AULEL.auleffectlist = auleffectlist       -- 分岐

return AULEL
