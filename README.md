tw_irc_bot
======

## なにこれ
Twitter の UserStream 接続を開いて、
ひたすらIRCのチャンネルにログを吐き出すだけの BOT。
生の hubot だとサービスまたがるとき面倒なので。
あと文字コード変換に iconv 使わないので Windows でも動く。
Windows向け配布用にそのままごちゃごちゃ入ってるのはご愛嬌。


## 必要なもの
 * node.js (0.8.16で動作確認)
	http://nodejs.org/
	Windowsの場合、
	公式サイトからセットアップを取得してインストールする。
	セットアップが自動的に PATH も通してくれるので、追加設定は不要。
	(インストール後再起動は必要かも)


## 設定方法
Twitter 関係の設定は config.coffee に記述する。
access_token と access_secret が空なので、
	http://kazy111.info/oauth/index.php
で取得し、設定にコピーする。

IRC 関係の設定は、runhubot.* に記述する。
HUBOT_IRC_* が設定項目。
	SERVER:  サーバ。
	PORT:    ポート。普通は6667。
	USERNAME:接続ユーザ名。nickとは別。
	PASSWORD:接続パスワード。不要な場合は空でOK。
	ROOMS:   参加するチャンネル。,区切りで複数指定可能。
	NICK:    nick。
文字コード設定のみ、 config.coffee の encoding に記述する。
UTF-8 の場合は UNICODE を、
ISO-2022-JP の場合は、 JIS を指定する。


## 実行方法
runhubot.* を実行するだけ。
ひたすらコンソールにログが出力される。

	twitter connected
という行があれば Twitter への接続はOK。
	ircbot has joined #kazy111
みたいな行があれば、IRC チャンネルへの参加もOK。


## 履歴
2013/01/06 ver 0.1
	初版

2013/01/08 ver 0.1.1
	Flood対策を導入
	改行を含む発言は、スペースで結合するように変更

2013/11/05 ver 0.1.2
	前回発言からwaitより間隔が空いている場合、すぐ発言するように変更


## 使用ライブラリ (node関係以外)
 * polygonplanet/Unzipper.js - GitHub
	https://github.com/polygonplanet/Unzipper.js

