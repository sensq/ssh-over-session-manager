# Windows用SSH over Session Managerスクリプト

## 概要

* あまり汎用的に作成していないため、雑な作りになっています。そのうち改良するかもしれません
* Assume Roleする前提で作成しています
  * Assume Rolle不要な環境では`ssh.ps1`の`--profile`の部分を消して実行すればよいです

## AWS CLIの設定

Region設定をしていないといけないようなので、Regionだけ記載しておいてください。  
あまり調べきれていないので詳細は不明。

```text
# ~\.aws\config に以下を記載
[default]
region = ap-northeast-1
```

## ローカルからSSHするための設定

ローカルのSSHConfigに以下を書いておいてください。  
ファイルのパスは基本的には`~/.ssh/config`で、このファイルに記載したホストがVSCodeのリモートエクスプローラーの`SSH TARGETS`に表示されます。

```text
Host 任意のホスト名
    HostName インスタンスID  # 例: i-01234567890123456
    IdentityFile キーのパス  # 例: ~\.ssh\ssh_over_session_manager_key （キーの名前は任意だが、後述のスクリプトに設定するキー名に合わせる）
    User 接続するユーザ名  # 例: ec2-user
    ProxyCommand aws ssm start-session --target %h --document-name AWS-StartSSHSession --region リージョン --profile 任意のプロファイル名（後述のスクリプトに設定するプロファイル名に合わせる）
    # 記載例
    # ProxyCommand aws ssm start-session --target %h --document-name AWS-StartSSHSession --region ap-northeast-1 --profile FooRole
```

## スクリプトの設定

各種スクリプトの冒頭にある変数へ設定を記載します。

```ps1
# assume_role.ps1

$Env:AWS_ACCESS_KEY_ID = "**YOUR_AWS_ACCESS_KEY_ID**"
$Env:AWS_SECRET_ACCESS_KEY = "**YOUR_AWS_SECRET_ACCESS_KEY**"
$Env:AWS_DEFAULT_REGION = "**YOUR_AWS_DEFAULT_REGION**"

$ACCOUNT_ID = "**YOUR_ACCOUNT_ID**"  # AWSのアカウントID
$ROLE_NAME = "**YOUR_ROLE_NAME**"  # AssumeRoleする先のRole名
$PROFILE_NAME = "**YOUR_PROFILE_NAME**"  # 作成するプロファイル名
```

```ps1
# ssh.ps1

$INSTANCE_ID = "**YOUR_INSTANCE_ID**"  # 接続先のインスタンスのID
$PROFILE = "**YOUR_PROFILE_NAME**"  # assume_role.ps1のPROFILE_NAMEに記載した値
$INSTANCE_OS_USER = "ec2-user"  # 接続するユーザ名
$SSH_KEY_NAME = "ssh_over_session_manager_key"  # キーの名前（基本的に固定でよい）
```

## スクリプト実行と接続

以下の順番でスクリプトを実行します。

```bash
# OpsbearDeveloperRoleにAssumeRoleする
assume_role.ps1
# SSH用の鍵を置く
ssh.ps1
```

VSCodeのリモートエクスプローラー（サイドメニューにある）をクリックし、そこから対象のホスト名を選択して接続します。

