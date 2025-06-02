import 'package:googleapis_auth/auth_io.dart';

class GetServerKey{

  Future<String> getServerKeyToken() async {

    final scopes=[
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging'
    ];
    //Here we pass our jason file we downloaded to get the server key
    final client=await clientViaServiceAccount(ServiceAccountCredentials.fromJson({
        "type": "service_account",
        "project_id": "login-form-97707",
        "private_key_id": "d8dc0130fb6cfcae79ea25aa76b7b5db9542a2a9",
        "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCpOJtkWmsWk5hc\n+sLzFxV6C8IaGdcC4GUmis63g3Om4TlA+lCO0ETFnA2kl5XmIkpuoxB7iOvxrpoI\n+RlzZvrpGK/6WqxfwOLaAB9APFl7aYQWvp0bsqkq9jPWyCRIcxph1bhW74l5OYQz\nlnG7tj3YMxu45GsXDidnEM4iyj10QrYK1InzPzLq5JECsxn7JPoyb562K6ToteIZ\nNFC9VBI9VTyrNft/SOos2a+LT/rNnubYQoD8Y/TtVttXws3Xe1FS1MDhL/E/kkY1\nQrzHYQHqHfqfdNtx/7LR5myUsyoEGuHuKRdOTROlGS4U2frslQZCzgJOaNqt3H6V\nlBjFUh4zAgMBAAECggEAU4Nf0SF8ezphNfX9s0m/rClUZFw/TCihUumrRk8mCwRZ\nJLPEgQ7Q+fNfmkzDSj2/HSX1svnqc66XT3lcMaNvjg1EgBoyutjvO+ZWhfWitbDn\n4u+0iqBcM5spD0Vb/rNroEABB0qVPpH/qBQF0j2I/QOQGWoFXe36zTcyfGHx/UdG\nuZpJ6p5IW+R0TeS4Ypr7mOzWyNostEtlCjbWUuSw8NqyhhqK9IwDgO+5Ht8a8DXB\nsKJMKhpRDjLuzZGk5cMzhqs4DRqTHGxTFcm2hZ6LGaEJQlLiOH5a2SwQWozi3Es9\nVkqIQL2GZQPB1TRFfXUJ+wr8U1URXvtFkan8DmO/vQKBgQDlOWhlRJvCUNdATfzo\nCYBm85nWgaUsbD+tcdEFB2JXTjoPJWrUKjhBf+TUcMBhALg7xQ3XufBMtBysoXHr\n4j0eNOLq4eLbNRqxOyBhZtpaFzKj7iHqSzdFKxHDiVUT2HvynUk6J11oiDbOaECQ\n/Z0XnZTcg/0pXLL0Q5GJRDG7zwKBgQC8/OZNxx02fv/5EFwWjijpudLJ25+4G4SA\nZVySVbOE8vq/NluUL+Rw7i634pJ3sCPlVJ+jcVxDUpE+cHhZ60Ts2CbifRT5heUL\n/ZtGxonW8dih4POb5kxrtVTtYMLOYCj52sNrvEFQna41/Gvtsn5Qb16dTygcyXpE\n8xOdoDXcXQKBgQDTRVpHHDlDnCcJCdh0NW23dgbwgoWusAbw4dp4/BlTxrIUi7Qu\n4MsA89QBSfrGbVdhH3pmvuYQjGFxa0wI0XjrgmszegcRa5yyhYCOxbGzH3Z5SV7R\nB4plohC5XLahmAKF1xpLE0Uwt3tsOwJnoJlNztwJc02+9cWrBSv6jHQaWQKBgF1e\n6X4F4QX6qwbnsUenhskq+NyoOHoihk1VRu45j08hKQdtmMNXAhtVYhmRxGGD0chN\nDe4XZMkSMxZRRPTQCyalCFkgCUvafjZ1XtER6CodJLWdyV3940XXuhTpmHWUBsqi\n7af9w5tLvDWJ99zhMg0VaP55jEzkshb8rXVUISg1AoGBAMST5U6jLPtuDjCILT0R\nckbJ3J4PmJnVcacsw32BTJomv69Zqjuj2/FacPh8kqKTmJ5YpOXsBtcnTBQtio/n\nweG0vyt/4JSAAFOkI2S1HhpcUskqxkqm6LMQRJcvQYGGAYIG2LYhqhP8zb/joIlh\nENzgw2AWxUZqAmSE7Il5Ll4c\n-----END PRIVATE KEY-----\n",
        "client_email": "firebase-adminsdk-9ff80@login-form-97707.iam.gserviceaccount.com",
        "client_id": "114714939337159923177",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-9ff80%40login-form-97707.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"


    }), scopes);
    final accessServerKey=client.credentials.accessToken.data;
    return accessServerKey;
  }
}