Param(
    [switch]$list
)

$CURRENT_DIR = pwd
cd $PSScriptRoot

trap{
    cd ${CURRENT_DIR}
    exit
}

# configリストの表示
if ($list){
    Get-ChildItem configs/*.ps1 -exclude template.ps1 | %{
        echo $_.BaseName
    }
    cd ${CURRENT_DIR}
    exit
}

# configの読み込みと読み込んだ内容の表示
if (![string]::IsNullOrEmpty(${ARGS}[0])){
    $TARGET = ${ARGS}[0]
    try{
        $INCLUDE_FILE_NAME = ${TARGET}
        . ${PSScriptRoot}\configs\${INCLUDE_FILE_NAME}.ps1
    }
    catch{
        Write-Host -ForegroundColor red $_
        exit
    }
    $desc = [PSCustomObject]@{
        "Account ID" = ${ACCOUNT_ID}
        "Environment" = ${DESC_ENVIRONMENT}
        "Purpose" = ${DESC_PURPOSE}
        "Use AssumeRole" = [string]${USE_ASSUME_ROLE}
        "Instance ID" = ${INSTANCE_ID}
    }
    echo ${desc} | ft
}

# AssumeRoleする
if ($USE_ASSUME_ROLE){
    Write-Host -ForegroundColor yellow "Try AssumeRole..."
    . ./assume_role.ps1 ${TARGET}
}
# AssumeRoleしない場合はアクセスキーをAWS CLIに直接設定する
else {
    aws configure set aws_access_key_id ${Env:AWS_ACCESS_KEY_ID} --profile ${PROFILE}
    aws configure set aws_secret_access_key ${Env:AWS_SECRET_ACCESS_KEY} --profile ${PROFILE}
    aws configure set region ${Env:AWS_DEFAULT_REGION} --profile ${PROFILE}
}

# 自動起動
if ($ENABLE_START_INSTANCE){
    $INSTANCE_STATE = $(aws ec2 describe-instances --instance-ids ${INSTANCE_ID} --query "Reservations[].Instances[].State.Name" --output text --profile ${PROFILE})
    if ($INSTANCE_STATE -eq "stopped"){
        Write-Host -ForegroundColor yellow "Try Start Instance..."
        try{
            aws ec2 start-instances --instance-ids ${INSTANCE_ID} --profile ${PROFILE} | Out-Null
            aws ec2 wait instance-running --instance-ids ${INSTANCE_ID} --profile ${PROFILE}
        }
        catch{
            Write-Host -ForegroundColor red $_
            exit
        }
        Write-Host -ForegroundColor green Done!
    }
}

# SSH接続可能状態にする
Write-Host -ForegroundColor yellow "Try SSH..."
. ./ssh.ps1 ${TARGET}

# 元のディレクトリに戻す
cd ${CURRENT_DIR}
