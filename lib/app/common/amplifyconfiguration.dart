const APP_CLIENT_ID = "6d1nh52naio43n93srqrdnq0v1";
const REGION = "us-east-1";
const AUTH_FLOW_TYPE = "REFRESH_TOKEN_AUTH";
const WEB_DOMAIN = "https://akki101.auth.us-east-1.amazoncognito.com/";
const POOL_ID = "us-east-1_GElAtp7cW";
const AWS_PASSWORD_POLICY_REGEX = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[\^$*.\[\]{}\(\)?\-“!@#%&/,><\’:;|_~`])\S{6,99}$';

const cognitoConfig = ''' 
      {
          "UserAgent": "aws-amplify-cli/2.0",
          "Version": "1.0",
          "auth": {
            "plugins": {
              "awsCognitoAuthPlugin":
                {
                  "IdentityManager": {
                      "Default": {}
                  },
                  "CredentialsProvider": {
                      "CognitoIdentity": {
                          "Default": {
                              "PoolId": "$POOL_ID",
                              "Region": "$REGION"
                          }
                      }
                  },
                  "CognitoUserPool": {
                      "Default": {
                          "PoolId": "$POOL_ID",
                          "AppClientId": "$APP_CLIENT_ID",
                          "Region": "$REGION"
                      }
                  }
                }
              }
        }
      }
      ''';
