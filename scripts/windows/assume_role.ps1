# configの読み込み
try{
    $INCLUDE_FILE_NAME = ${ARGS}[0]
    . ${PSScriptRoot}\configs\${INCLUDE_FILE_NAME}.ps1
}
catch{
    Write-Host -ForegroundColor red $_
    exit
}

# Assume Role用のパラメータ取得
try{
    $ASSUME_ROLE_TMP = aws sts assume-role --role-arn arn:aws:iam::${ACCOUNT_ID}:role/${ROLE_NAME} --role-session-name tmp_session
    if(!$?){
        throw "AssumeRoleError"
    }
}
catch{
    Write-Host -ForegroundColor red $_
    exit
}

# Assume Roleの設定
$ASSUME_AWS_ACCESS_KEY_ID = echo $ASSUME_ROLE_TMP | jq -r ".Credentials.AccessKeyId"
$ASSUME_AWS_SESSION_TOKEN = echo $ASSUME_ROLE_TMP | jq -r ".Credentials.SessionToken"
$ASSUME_AWS_SECRET_ACCESS_KEY = echo $ASSUME_ROLE_TMP | jq -r ".Credentials.SecretAccessKey"
aws configure set aws_access_key_id ${ASSUME_AWS_ACCESS_KEY_ID} --profile ${PROFILE}
aws configure set aws_secret_access_key ${ASSUME_AWS_SECRET_ACCESS_KEY} --profile ${PROFILE}
aws configure set aws_session_token ${ASSUME_AWS_SESSION_TOKEN} --profile ${PROFILE}
aws configure set region ${Env:AWS_DEFAULT_REGION} --profile ${PROFILE}

Write-Host -ForegroundColor green Done!
