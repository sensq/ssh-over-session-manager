# AWS CLIの設定
$Env:AWS_ACCESS_KEY_ID = "**YOUR_AWS_ACCESS_KEY_ID**"
$Env:AWS_SECRET_ACCESS_KEY = "**YOUR_AWS_SECRET_ACCESS_KEY**"
$Env:AWS_DEFAULT_REGION = "**YOUR_AWS_DEFAULT_REGION**"

# Assume Roleのパラメータ
$ACCOUNT_ID = "**YOUR_ACCOUNT_ID**"
$ROLE_NAME = "**YOUR_ROLE_NAME**"
$PROFILE = "**YOUR_PROFILE_NAME**"
$ROLE_SESSION_NAME = "tmp_session"  # セッション名（基本的に固定でよい）

# SSH先のインスタンス情報
$INSTANCE_ID = "**YOUR_INSTANCE_ID**"
$INSTANCE_OS_USER = "ec2-user"  # 接続するユーザ名
$SSH_KEY_NAME = "ssh_over_session_manager_key"  # SSHキー名（基本的に固定でよい）
