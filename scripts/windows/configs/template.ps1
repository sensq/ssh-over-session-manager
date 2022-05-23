# 設定ファイルについての説明
$DESC_ENVIRONMENT = "Test"  # インスタンスが置かれているAWS環境の説明
$DESC_PURPOSE = "Sample"  # インスタンスの用途

# AWS CLIの設定
$Env:AWS_ACCESS_KEY_ID = "**YOUR_AWS_ACCESS_KEY_ID**"
$Env:AWS_SECRET_ACCESS_KEY = "**YOUR_AWS_SECRET_ACCESS_KEY**"
$Env:AWS_DEFAULT_REGION = "**YOUR_AWS_DEFAULT_REGION**"

# AWS環境の接続先情報
$ACCOUNT_ID = "**YOUR_ACCOUNT_ID**"
$USE_ASSUME_ROLE = $True  # 接続前にAssumeRoleを行うか？
$ENABLE_START_INSTANCE = $True  # スクリプト実行時にインスタンスが停止していたら起動するか？
$INSTANCE_ID = "**YOUR_INSTANCE_ID**"
$INSTANCE_OS_USER = "ec2-user"  # 接続するユーザ名

# ローカルのSSH Config設定
$PROFILE = "**YOUR_PROFILE_NAME**"
$ROLE_SESSION_NAME = "tmp_session"  # セッション名（基本的に固定でよい）
$SSH_KEY_NAME = "ssh_over_session_manager_key"  # SSHキー名（基本的に固定でよい）

# Assume Roleするロール名（USE_ASSUME_ROLEがTrueの場合は指定が必須）
$ROLE_NAME = "**YOUR_ROLE_NAME**"
