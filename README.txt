* サンプル


** ファイル構成

$ tree
.
|-- README.txt
|-- bin
|   `-- server.pl
`-- etc
    `-- httpd
        |-- bad-proxy.conf
        |-- proxy.conf
        `-- rewrite.conf


** インストール方法

適当なディレクトリ (例として /etc/apache2/techblog-sample) に etc/httpd 以下のファイルをコピーして、 /etc/apache2/ httpd.conf ファイルからインクルードしてください。

NameVirtualHost *
Include /etc/apache2/techblog-sample/bad-proxy.conf
Include /etc/apache2/techblog-sample/proxy.conf
Include /etc/apache2/techblog-sample/rewrite.conf


bin/server.pl はサンプル用のアプリケーションサーバです。 HTTP::Engine モジュールが必要ですので別途 CPAN からインストールしてください。


** 起動方法

/etc/hosts ファイルに検証用のホストを追記します。

127.0.0.1 proxy.example.com
127.0.0.1 bad-proxy.example.com
127.0.0.1 rewrite.example.com


Mac OSX に標準でバンドルされている apache を再起動します。

$ sudo apachectl configtest
$ sudo apachectl restart


アプリケーションサーバを起動します。

$ bin/server.pl


** 動作確認

# proxy.conf
$ lwp-request -deS http://proxy.example.com/
GET http://proxy.example.com/ --> 200 OK

$ lwp-request -deS http://proxy.example.com/redirect_to_foo
GET http://proxy.example.com/redirect_to_foo --> 302 Found
GET http://proxy.example.com/foo --> 200 OK


# bad-proxy.conf
$ lwp-request -deS http://bad-proxy.example.com/redirect_to_foo
GET http://bad-proxy.example.com/redirect_to_foo --> 302 Found
GET http://localhost:8080/foo --> 200 OK
# bad-proxy.example.com ではなく localhost:8080 になっていることに注目


# rewrite.conf
$ lwp-request -deS http://rewrite.example.com/redirect_to_foo
GET http://rewrite.example.com/redirect_to_foo --> 302 Found
GET http://rewrite.example.com/foo --> 200 OK

$ lwp-request -deS http://rewrite.example.com/apache_header.gif
GET http://rewrite.example.com/apache_header.gif --> 200 OK
# /Library/WebServer/Documents/manual/images/apache_header.gif が返されている
