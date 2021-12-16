# AWS CLIの設定
$Env:AWS_ACCESS_KEY_ID = "**YOUR_AWS_ACCESS_KEY_ID**"
$Env:AWS_SECRET_ACCESS_KEY = "**YOUR_AWS_SECRET_ACCESS_KEY**"
$Env:AWS_DEFAULT_REGION = "**YOUR_AWS_DEFAULT_REGION**"

# Assume Roleのパラメータ
$ACCOUNT_ID = "**YOUR_ACCOUNT_ID**"
$ROLE_NAME = "**YOUR_ROLE_NAME**"
$PROFILE_NAME = "**YOUR_PROFILE_NAME**"

# Assume Role用のパラメータ取得
$ASSUME_ROLE_TMP = aws sts assume-role --role-arn arn:aws:iam::${ACCOUNT_ID}:role/${ROLE_NAME} --role-session-name tmp_session

# Assume Roleの設定
$ASSUME_AWS_ACCESS_KEY_ID = echo $ASSUME_ROLE_TMP | jq -r ".Credentials.AccessKeyId"
$ASSUME_AWS_SESSION_TOKEN = echo $ASSUME_ROLE_TMP | jq -r ".Credentials.SessionToken"
$ASSUME_AWS_SECRET_ACCESS_KEY = echo $ASSUME_ROLE_TMP | jq -r ".Credentials.SecretAccessKey"
aws configure set aws_access_key_id ${ASSUME_AWS_ACCESS_KEY_ID} --profile ${PROFILE_NAME}
aws configure set aws_secret_access_key ${ASSUME_AWS_SECRET_ACCESS_KEY} --profile ${PROFILE_NAME}
aws configure set aws_session_token ${ASSUME_AWS_SESSION_TOKEN} --profile ${PROFILE_NAME}
