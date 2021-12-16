# SSH先のインスタンス情報
$INSTANCE_ID = "**YOUR_INSTANCE_ID**"
$PROFILE = "**YOUR_PROFILE_NAME**"
$INSTANCE_OS_USER = "ec2-user"  # 他のユーザにしたい場合は変更する
$SSH_KEY_NAME = "ssh_over_session_manager_key"  # 基本的に固定でよい

# インスタンスのAZ取得
$AZ = aws ec2 describe-instances `
    --instance-ids ${INSTANCE_ID} `
    --query 'Reservations[0].Instances[0].Placement.AvailabilityZone' `
    --output text `
    --profile ${PROFILE}

# SSH接続用の一時的なキーペアを作成
Write-Output "y" | ssh-keygen -q -N '""' -f ${HOME}/.ssh/${SSH_KEY_NAME}

# 一時的にインスタンスへ公開鍵を設定（60秒間使用可能）
aws ec2-instance-connect send-ssh-public-key `
    --instance-id ${INSTANCE_ID} `
    --instance-os-user ${INSTANCE_OS_USER} `
    --availability-zone ${AZ} `
    --ssh-public-key file://${HOME}/.ssh/${SSH_KEY_NAME}.pub `
    --profile ${PROFILE}
