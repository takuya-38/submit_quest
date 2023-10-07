#!/bin/bash

#パスワードマネージャーのプログラム

echo "パスワードマネージャーへようこそ！"

echo "GPG鍵のユーザID(メールアドレス)を入力してください："
read -p '>' user_id

while true
do
	#ユーザーに選択肢を表示し入力を受け取る
	echo "次の選択肢から入力してください(Add Password/Get Password/Exit):"
	read -p ">" option
	echo

	#入力に応じて処理を分岐
	case "$option" in
		"Add Password")
			#ユーザーからサービス名、ユーザー名、パスワードを受け取る
			read -p 'サービス名を入力してください:' service_name
			read -p 'ユーザー名を入力してください:' user_name
			read -p 'パスワードを入力してください:' password

			#パスワードファイルの復号後、入力情報を追記
                        gpg -a -o passwords.txt -d passwords.asc 2> /dev/null
			echo "$service_name:$user_name:$password" >> passwords.txt

			#追記されたパスワードファイルの暗号化
			gpg -a -o passwords.asc -e -r $user_id passwords.txt
			rm -f passwords.txt

			echo -e "\nパスワードの追加は成功しました。";;

		"Get Password")
			#ユーザーからサービス名を受け取る
			read -p 'サービス名を入力してください:' service_name

			#パスワードファイルの復号後、該当情報を取得
			gpg -a -o passwords.txt -d passwords.asc 2> /dev/null
			creds=$(grep ^$service_name\: passwords.txt)
			rm -f passwords.txt

			#該当する情報が登録されている場合、表示する
			if [ -z "$creds" ]
			then
				echo "そのサービスは登録されていません。"
			else
				cred_list=(${creds//:/ })
				echo "サービス名：${cred_list[0]}"
				echo "ユーザー名：${cred_list[1]}"
				echo "パスワード：${cred_list[2]}"
				echo
			fi;;

		"Exit")
			#プログラム終了
			echo "Thank you!"
			break;;

		*)
			#不正な入力に対するエラーメッセージ
			echo "入力が間違えています。Add Password/Get Password/Exit から入力してください。";;
	esac
done