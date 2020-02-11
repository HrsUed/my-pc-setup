#!/bin/bash
echo "[開始] 新しい鍵を生成して更新します。"

pushd ~/.ssh > /dev/null

if [[ -z "$1" ]]; then
  prefix=$(whoami)
else
  prefix="$1"
fi

readonly NOW=$(date "+%Y%m%d%H%M%S")
readonly DEFAULT_KEY_NAME="${prefix}-private-key-${NOW}"

printf "秘密鍵の名称を拡張子抜きで入力してください（デフォルト=${DEFAULT_KEY_NAME}）："
read private_key_name

if [[ -z "${private_key_name}" ]]; then
  private_key_name="${DEFAULT_KEY_NAME}"
fi

openssl genrsa 2048 > "${private_key_name}.pem" 2> /dev/null

RC=$?
if [[ ${RC} -ne 0 ]]; then
  echo "秘密鍵の生成に失敗しました。リターン=${RC}"
  popd > /dev/null
  exit 0
fi

chmod 600 "${private_key_name}.pem"
echo "秘密鍵${private_key_name}.pemを生成しました。"

ssh-keygen -y -f "${private_key_name}.pem" > "${private_key_name}.pub"

RC=$?
if [[ ${RC} -ne 0 ]]; then
  echo "公開鍵の生成に失敗しました。リターン=${RC}"
  popd > /dev/null
  exit 0
fi

cat "${private_key_name}.pub" >> authorized_keys
echo "authorized_keysに追記しました。"

rm "${private_key_name}.pub"

echo;
echo "[完了] 秘密鍵を生成し、authorized_keysファイルを更新しました。"
echo "秘密鍵情報をクライアントへコピーしてください。"

popd > /dev/null
exit 0

