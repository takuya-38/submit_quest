#!/bin/bash

#パスワードマネージャーのプログラム

echo "パスワードマネージャーへようこそ！"

#ユーザーからサービス名、ユーザー名、パスワードを受け取る
read -p 'サービス名を入力してください:' service_name
read -p 'ユーザー名を入力してください:' user_name
read -p 'パスワードを入力してください:' password

#入力をパスワードファイルへ追加
echo "$service_name:$user_name:$password" >> passwords.txt

#プログラム終了
echo "Thank you!"