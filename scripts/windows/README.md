# Windows用SSH over Session Managerスクリプト

## 概要

Assume Roleを行ってからSSMを使用してSSHするスクリプトの実行方法についての説明です。  
Assume Roleする前提で作成していますが、Assume Roleが不要な環境では`~/.aws/credentials`に任意の名前でProfileを追記してから実行すればよいです。  
もしくは、`default`の設定だけ行って`ssh.ps1`の`--profile`の部分を消して実行してください。

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
```

記載例

```text
Host 作業用インスタンス
    HostName i-01234567890123456
    IdentityFile ~\.ssh\ssh_over_session_manager_key
    User ec2-user
    ProxyCommand aws ssm start-session --target %h --document-name AWS-StartSSHSession --region ap-northeast-1 --profile FooRole
```

## スクリプトの設定

`configs`ディレクトリの中の[template.ps1](./configs/template.ps1)ファイルを参考にして設定ファイルを作成してください。

### パラメータの補足

基本的に半角英数字のみで記載してください。  
説明を日本語で記載したい場合等はスクリプトのファイルの文字コードをSJISにして保存してください。

- 設定ファイルについての説明
    - 備忘用に、どんなインスタンスに接続するための設定ファイルなのかを記載してください
- AWS CLIの設定
    - インスタンスがあるリージョン、使用するIAM Userに作成したアクセスキーを記載してください
- AWS環境の接続先情報
    - `USE_ASSUME_ROLE`: `$True`を指定すると接続前にAssume Roleを行います
    - `ENABLE_START_INSTANCE`: `$True`を指定すると接続時にインスタンスが停止している場合は自動的に起動します
- ローカルのSSH Config設定
    - `PROFILE`: SSH Configの`ProxyCommand`で指定したプロファイル名を記載してください
    - `ROLE_SESSION_NAME`: セッションマネージャのログに記載されるセッション名に使われます
        - 基本的に固定でよいですが、同一のセッション名で同時に複数のセッションを張ることはできないため、使い方によっては注意してください
    - `SSH_KEY_NAME`: ローカルで作成するキーの名前に使われます

## スクリプト実行

引数に指定した名前のconfigファイルの名前を指定して実行します。  
問題なく実行完了したら「Done!」と出力されます。

以下は`configs`に`foo.ps1`という名前で作成した設定ファイルを読み込む場合の実行方法です。

```bash
.\scripts\windows\ssh-over-session-manager.ps1 foo
```

また、`-list`オプションを付けると作成済みのconfigファイルのリストを表示します。

```bash
.\scripts\windows\ssh-over-session-manager.ps1 -l
```

## 接続

VSCodeのサイドメニューにあるリモートエクスプローラーをクリックし、そこから対象のホスト名を選択して接続します。  
配置したキーは1分間しか使用できないため、1分以内に接続してください。  
1分を過ぎてしまった場合は再度スクリプトを実行してから接続してください。
