# Windows用SSH over Session Managerスクリプト

## 概要

* あまり汎用的に作成していないため、雑な作りになっています。そのうち改良するかもしれません
* Assume Roleする前提で作成しています
  * Assume Rolle不要な環境では`ssh.ps1`の`--profile`の部分を消して、`~/.aws/credentials`に任意の名前でProfileを追記してから実行すればよいです

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

`configs`ディレクトリの中に`template.ps1`ファイルを参考にして設定ファイルを作成してください。

## スクリプト実行

以下の順番でスクリプトを実行します。  
引数に指定した名前のconfigファイルを読み込んで実行します。  
どちらのスクリプトも、問題なく実行完了したら「Done!」と出力されます。

以下は`configs`に`foo.ps1`という名前で作成した設定ファイルを読み込む場合の実行方法です。

```bash
# OpsbearDeveloperRoleにAssumeRoleする
.\scripts\windows\assume_role.ps1 foo
# SSH用の鍵を置く
.\scripts\windows\ssh.ps1 foo
```

## 接続

VSCodeのリモートエクスプローラー（サイドメニューにある）をクリックし、そこから対象のホスト名を選択して接続します。  
`ssh.ps1`で配置したキーは1分間しか使用できないため、1分以内に接続してください。  
1分を過ぎてしまった場合は再度`ssh.ps1`を実行してから接続してください。
