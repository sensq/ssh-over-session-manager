# configの読み込み
try{
    $INCLUDE_FILE_NAME = ${ARGS}[0]
    . ${PSScriptRoot}\configs\${INCLUDE_FILE_NAME}.ps1
}
catch{
    Write-Host -ForegroundColor red $_
    exit
}

# インスタンスのAZ取得
try{
    $AZ = aws ec2 describe-instances `
        --instance-ids ${INSTANCE_ID} `
        --query 'Reservations[0].Instances[0].Placement.AvailabilityZone' `
        --output text `
        --profile ${PROFILE}
    if(!$?){
        throw "GetAvailabilityZoneError"
    }
}
catch{
    Write-Host -ForegroundColor red $_
    exit
}

# SSH接続用の一時的なキーペアを作成
Write-Output "y" | ssh-keygen -q -N '""' -f ${HOME}/.ssh/${SSH_KEY_NAME} | Out-Null

# 一時的にインスタンスへ公開鍵を設定（60秒間使用可能）
try{
    aws ec2-instance-connect send-ssh-public-key `
        --instance-id ${INSTANCE_ID} `
        --instance-os-user ${INSTANCE_OS_USER} `
        --availability-zone ${AZ} `
        --ssh-public-key file://${HOME}/.ssh/${SSH_KEY_NAME}.pub `
        --profile ${PROFILE} | Out-Null
    if(!$?){
        throw "SendKeyError"
    }
}
catch{
    Write-Host -ForegroundColor red $_
    exit
}

Write-Host -ForegroundColor green Done!
