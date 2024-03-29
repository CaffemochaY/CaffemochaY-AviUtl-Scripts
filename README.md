# CaffemochaY's AviUtl Scripts

自作のAviUtlスクリプトたちです

## ダウンロード/インストール方法

右上の `Code` の `Download ZIP` または **[ここ](https://github.com/CaffemochaY/CaffemochaY-AviUtl-Scripts/archive/refs/heads/main.zip)** からDLして、 `script` フォルダの中身をスクリプトが機能する場所に置いてください

developブランチには最新のものがあるので、最新版を使用したい場合はdevelopブランチの方からDLして導入してください

### フォルダ概要

- `alias_how-to-use` フォルダには、使用例エイリアスが入っています  
  エイリアスを認識できるディレクトリに配置するか、D&Dで使用してください

- `script/.old` フォルダには、大きなアップデートがあったスクリプトの過去バージョンが入ってます  
  もし、アップデート後のスクリプトが正常に動作しない時は試してみてください

- `script/.as-needed` フォルダには、使いどころが分からないスクリプトが入っています  
  使ってみたいな～と思ったら入れてみるといいと思います

## 各種スクリプトの説明

スクリプトファイルの先頭にコメントで説明文が記載してあります  
使い方・注意書き・更新点などはここに書いてあります

`スクリプト内説明` をクリックして展開すると、スクリプトファイル内に記載している説明が見れるようになってます

## List

- [ソフトフォーカス](#ソフトフォーカス)
- [グラデーション縁取り＋](#グラデーション縁取り)
- [コントラスト比自動計算](#コントラスト比自動計算)
- [ディフュージョン](#ディフュージョン)
- [任意番号個別エフェクト](#任意番号個別エフェクト)
- [斜めブラインドシャドー](#斜めブラインドシャドー)

.as-needed

- [マスク画像化](#マスク画像化)

---

### ソフトフォーカス

紹介動画 : <https://www.nicovideo.jp/watch/sm40105334>

- `ソフトフォーカス.anm`

  - いわゆる**ソフトフォーカス加工**ができる
    - 画像(立ち絵、背景など)を柔らかい雰囲気にする
    - ついでに立体っぽさを演出出来るかも
    - 影の雰囲気や線の固さが主に変化する

  - 重ねる画像のみに色調補正や単色化をかけられるようにした

  - <details><summary>スクリプト内説明</summary>

    ---

    ソフトフォーカス.anm / ver.2.0.2  
    Copyright (c) 2022 CaffemochaY

    - 立ち絵等の画像を柔らかい雰囲気にします  
    - ついでに立体っぽさを演出出来るかもしれません  
    - 影の雰囲気や線の固さが主に変化します

    "ぼかし", "拡散光", "単色化", "色調補正" の順番でエフェクトをかけます

    - parameter
      - alpha : エフェクトをかけたものの透明度(適応する強さに相当)
      - その他 : "ぼかし", "拡散光", "単色化", "色調補正" のパラメータ各種

    - 注意
      - `X,Y調整` は、絶対値が `"最大画像サイズ" - w(or h) - (blur_range + diffusion) * 2` より小さくなるようにしないと元画像がクリッピングされます
      - `合成モード(0-12)` のうち、`10` , `11` , `12` はうまくいかない場合があります
        - 詳細は `lua.txt` を見て下さい

    - changelog
      - ver.2
        - obj.copybufferを使わないようにした
        - 画像データのキャッシュ数を `0` にしても機能するようにした
        - 各種パラメータが `0` の時、パラメータが `0` の一部のエフェクトを無効化し、動作を軽量化した
      - ver.2.0.1
        - バージョン表記を3桁に変更
      - ver.2.0.2
        - 文字コードの正規化

    </details>

### グラデーション縁取り＋

紹介動画 : <https://www.nicovideo.jp/watch/sm40105334>

- `グラデーション縁取り＋.anm`

  - **グラデーションが付いた縁取り**ができる
  - **半透明縁取り**もできる
    - [rikky_module.dll](https://hazumurhythm.com/a/a2Z/) を導入していれば、ファイル選択ダイアログが出せる

  - <details><summary>スクリプト内説明</summary>

    ---

    グラデーション縁取り＋.anm / ver.2.0.2  
    Copyright (c) 2022 CaffemochaY

    グラデーションがかかった縁取りを1オブジェクトで完結させることが出来るようにするスクリプトです  
    縁取り部分の透明度も設定できます  
    グラデーションの強さを `0` にすれば、ただの透過縁取りとしても使えます  
    開始色, 終了色を空欄にすると、**色選択無し**の状態になります

    `rikky_module.dll` がこのスクリプトで読める場所にあれば、ファイル選択ダイアログが出せます  
    `rikkymodule&memory` を導入していない場合は、`\` をエスケープしてください

    - parameter
      - 縁取り, グラデーションのパラメータ各種
      - alpha : 縁取り部分の透明度

    - changelog
      - ver.2
        - obj.copybufferを使わないようにした
        - 画像データのキャッシュ数を `0` にしても機能するようにした
      - ver.2.0.1
        - バージョン表記を3桁に変更
      - ver.2.0.2
        - 文字コードの正規化

    </details>

### コントラスト比自動計算

紹介動画 : <https://www.nicovideo.jp/watch/sm40317056>

- `コントラスト比自動計算.anm` / `コントラスト比自動計算.obj` / `contrast_ratio_cal.lua`

  - 字幕などの**色をコントラスト比を参考にしながら決める**ことができる
  - **客観的に見やすいよう**にできる
    - `コントラスト比自動計算.anm`
      - アンカー位置の色を取得して、コントラスト比を自動計算する
    - `コントラスト比自動計算.obj`
      - ダイアログで2色を指定して、コントラスト比を自動計算する

  - コンソールがあるかつ、 `debug_print` にチェックを入れていると、カラーコードや輝度、コントラスト比がコンソールで見られるようになっている

  - <details><summary>スクリプト内説明</summary>

    ---

    コントラスト比自動計算.anm / ver.1.0.2  
    Copyright (c) 2022 CaffemochaY

    アンカーで2色を取得して、その2つのコントラスト比を自動で計算するスクリプト  
    [WCAG 2.0](https://www.w3.org/TR/WCAG20-TECHS/G17.html#G17-procedure)基準で色のコントラスト比を計算する

    - parameter
      - 文字色 / 文字装飾色 : 色
      - 文字サイズ, フォント名, 文字装飾 : テキストのパラメータ
      - 文字不透明度 : 文字の不透明度
      - info : アンカー, コントラスト比の表示を設定
      - debug_print : debug_printに値を返すかの指定

    - changelog
      - ver.1.0.1
        - バージョン表記を3桁に変更
      - ver.1.0.2
        - 文字コードの正規化

    ---

    コントラスト比自動計算.obj / ver.1.0.2  
    Copyright (c) 2022 CaffemochaY

    ダイアログで2色を指定して、その2つのコントラスト比を自動で計算するスクリプト  
    [WCAG 2.0](https://www.w3.org/TR/WCAG20-TECHS/G17.html#G17-procedure)基準で色のコントラスト比を計算する

    - parameter
      - 文字色 / 背景色 : 色
      - 文字サイズ, フォント名, 文字装飾 : テキストのパラメータ
      - 背景margin : 文字の範囲から、どれだけ余白をとるかの指定
      - debug_print : debug_printに値を返すかの指定

    - changelog
      - ver.1.0.1
        - バージョン表記を3桁に変更
      - ver.1.0.2
        - 文字コードの正規化

    ---

    contrast_ratio_cal.lua / ver.1.0.2  
    Copyright (c) 2022 CaffemochaY

    sourse : [WCAG 2.0](https://www.w3.org/TR/WCAG20-TECHS/G17.html#G17-procedure)

    - changelog
      - ver.1.0.1
        - バージョン表記を3桁に変更
      - ver.1.0.2
        - 文字コードの正規化

    </details>

### ディフュージョン

紹介動画 : <https://www.nicovideo.jp/watch/sm40317056>

- `ディフュージョン.anm`

  - **LuaJITが必須**
    - LuaJITを導入していない場合、 `LuaJITを導入して下さい` と出るようになっています
      - 導入していない場合、自分でビルドするか、[ここ](https://scrapbox.io/ePi5131/LuaJIT)などから `LuaJIT-2.1.0-beta3` の `lua51.dll` をDLし、AviUtlに元から入っている `lua51.dll` を上書きして下さい

  - 閾値を指定し、その指定した数値以上の輝度の光を拡散させる
    - 元の色味を保ったまま絵の空気を柔らかくできる
    - ソフトフォーカスとは違い、明るい部分のみ拡散させる
      - 輝度最低よりも暗い部分は拡散させない

  - 元画像を表示させずに、拡散させる部分だけを表示させることもできる
    - `without_original` にチェックを入れると出来る

  - <details><summary>スクリプト内説明</summary>

    ---

    ディフュージョン.anm / ver.1.3.0  
    Copyright (c) 2022 CaffemochaY

    LuaJITが必須 （LuaJIT 2.1.0-beta3 推奨）

    - 閾値を指定し、その指定した数値以上の輝度の光を拡散させる
    - 元の色味を保ったまま絵の空気を柔らかくできる

    - parameter
      - 輝度最低 / 最高 : 拡散させたいハイライト部分の輝度の最低、最高を指定する
        - 輝度最低より下の輝度は `0` , 輝度最高より上の輝度は `1` に補正する
      - 輝度上限 : それ以上の輝度の部分を拡散させないようにする
        - 輝度上限以上の輝度の部分の `alpha` を `0` にする
      - alpha : ハイライト部分の透明度倍率(%)
        - alpha_Insert : `obj.track3` よりも自由に指定できる透明度倍率
          - `100` 以上を指定すると、通常よりも濃くできる
      - without_original : 元画像を表示するかどうか （`1` で表示しない）
      - ぼかし, 色調補正 各種パラメータ

    - 注意
      - `合成モード(0-12)` のうち、`10` , `11` , `12` はうまくいかない場合があります
        - 詳細は `lua.txt` を見て下さい
      - 合成モードは変えない方が良いと思われる
        - 変えるとしたら、`0` , `1` , `4` , `5` , `6` , `8` 辺り
        - デフォルトは `6`
      - `_dp1~10,13~16` をglobal変数で使用しています

    - changelog
      - ver.1.1
        - 0除算のパターンを考慮していなかったため該当部分の修正
      - ver.1.2
        - 輝度上限を設定出来るようにした
          - 白飛びしにくくなるように設定出来るようになったはず
      - ver.1.2.1
        - バージョン表記を3桁に変更
      - ver.1.3.0
        - pixel処理のループを改良
        - 文字コードの正規化

    </details>

### 任意番号個別エフェクト

- `@任意番号個別エフェクト.anm` / `aviutl_effect_list.lua`

  - 個別オブジェクトにおいて、番号を指定してそれのみにエフェクトを適応する
    - 使用例
      - ある文字からグラデーションの色を変える
      - 一部のオブジェクトだけ縁取りをする

  - <details><summary>スクリプト内説明</summary>

    ---

    任意番号個別エフェクト.anm / ver.1.2.2  
    Copyright (c) 2022 CaffemochaY

    - parameter
      - 開始番号 / 終了番号 : エフェクトをかけたい `index` を指定する
        - index_table : "table" でエフェクトをかけたい `index` を複数範囲指定する
          - `index` は `0` スタート

      - 関数版
        - Effect_insert : 関数などでエフェクトを指定する ( `obj.effect` , `function` など)
      - テンプレート版
        - _name : エフェクトの名前
        - track0~7 : トラックバー (3,4,5,6,7 は "table" で指定)
        - color1,2 : 色
        - check0~4 : チェックの値を 0,1 で指定 (1,2,3,4 は "table" で指定)
        - mode : 合成モードなどの `.exo` で `mode` の値を指定
        - type : 図形の種類などの `.exo` で `type` の値を指定
        - name/file : アニメーション効果の名称やファイルのパスなどを指定
        - color_yc1,2 : YCbCr の各種値を "table" でエフェクトを指定 (数値でも可)
        - seed/変形方法 : ノイズの `seed` を指定 / ディスプレイスメントマップの変形方法を指定
        - param : アニメーション効果のダイアログパラメータを指定

    - 注意
      - `Effect_insert()` の初めの `]]` は消さないように
      - `Effect_insert` は、 スクリプト制御で `Effect_insert` で関数を定義して代入すると、stack overflow になる
      - "table" の欄は "table" で値を指定すること

    - changelog
      - ver.1.1
        - `stack overflow` について追記
      - ver.1.2
        - 設定ダイアログの番号が誤っていたので修正
      - ver.1.2.1
        - バージョン表記を3桁に変更
      - ver.1.2.2
        - 文字コードの正規化
        - コードのフォーマット

    ---

    aviutl_effect_list.lua / ver.1.0.2  
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
      - ver.1.0.2
        - 文字コードの正規化

    </details>

### 斜めブラインドシャドー

- `斜めブラインドシャドー.anm`

  - ブラインドがかかった影をつけることができる
  - Timさんの[斜めブラインド(改)](https://tim3.web.fc2.com/sidx.htm#DiaSha)が必須

  - <details><summary>スクリプト内説明</summary>

    ---

    斜めブラインドシャドー.anm / ver.1.0.0  
    Copyright (c) 2022 CaffemochaY

    Timさんの[斜めブラインド(改)](https://tim3.web.fc2.com/sidx.htm#DiaSha)が必須

    - parameter
      - alpha : 影の透明度
      - ratio : ブラインドの適応割合
      - width : ブラインドの幅
      - angle : ブラインドの角度
      - X : 影のX座標
      - Y : 影のY座標
      - 基準 : ブラインドの基準座標
      - 時間差[%] : ブラインドの幅のずれ
      - ぼかし : 影のぼかし度合い
      - 背景色 : 影のベースになる色
      - 斜線色 : 影のブラインドがかかった方の色
      - insert : trackパラメータに別の式の挿入ができるやつ

  </details>

## as-needed

### マスク画像化

- `マスク画像化.anm`

  - アルファ or RGBの各要素 をグレースケールに変換する

  - <details><summary>スクリプト内説明</summary>

    ---

    マスク画像化.anm / ver.1.2.1  
    Copyright (c) 2022 CaffemochaY

    アルファ or RGBの各要素 をグレースケールに変換する

    - changelog
      - ver.1.1.0
        - オブジェクトの生成の方法を変更
      - ver.1.2.0
        - pixel処理のループを改良
      - ver.1.2.1
        - 文字コードの正規化

  </details>

---

## License

MIT ライセンス  
[LICENSE](LICENSE)

## 謝辞

引用、参考にさせていただきました、ありがとうございます

- [ソフトフォーカス これで直る？](https://scrapbox.io/ePi5131/ソフトフォーカス_これで直る？)
