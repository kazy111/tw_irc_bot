module.exports = {
    # Twitter の アクセストークン等
    # http://kazy111.info/oauth/ 等で取得する
    # 認証したユーザのTLが流れます
    tokens: {
      consumer_key: "Ae8yeWf7XHs3ObdXI6Feg"
      consumer_secret: "KJiYIr1ACO7ZSO114Xa0V4edYs7Ol1963Yn3QDang"
      access_token_key: ""
      access_token_secret: ""
    }

    # 検索語
    # 空白の場合、認証ユーザのHome TLを表示し、検索語を入れると検索TLを流します。
    # ※Stream APIは日本語対応していないので、半角スペース区切りの単語しか検索できません
    # (ハッシュタグ等の単語前後に全角スペースがあるだけでひっかかりません)
    track: ''

    # favorite等のイベントを表示するか
    event_enable: false

    # IRCの文字コード (UNICODE, SJIS, JIS, EUCJP)
    encoding: 'JIS'

    # 発言間隔[ms]
    # Flood対策。サーバによって適切な値が変わる。
    # 頻繁にFlood Exceededでkickされるようなら数字を上げる。
    wait: 2500

    # 発言にnoticeを使う
    use_notice: true
    
    # 発言する内容の条件
    # 
    # 発言ユーザ(Twitter ID)別に指定。マッチしない場合は default で判定。
    # defaultがない、もしくは条件が空の場合は、判定せずに通します。
    # また、条件が不正な場合も通します。
    #
    # 条件の複数指定は、演算子を用います。使える演算子は次の通り。
    #   AND : &&
    #   OR  : ||
    #   NOT : !
    #   括弧: ( )
    #
    # 演算子や単語の間には、必ず空白を入れて下さい。
    #   ×  : hoge&&(piyo||fuga)
    #   ○  : hoge && ( piyo || fuga )
    filter: {
      # kazy_dev の発言で、"ほげ" を含み、"ぴよ" を含まない
      # kazy_dev: 'ほげ　&& ! ぴよ'
      default : ''
    }

    debug: true
}
