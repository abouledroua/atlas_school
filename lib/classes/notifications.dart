import 'package:awesome_notifications/awesome_notifications.dart';

int createUniqueId() => DateTime.now().millisecondsSinceEpoch.remainder(100000);

String appTitle = 'ATLAS School';
int idMessage = 1, idAnnounce = 2, idUpload = 3;

Future<void> createMessageNotification() async =>
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: idMessage,
            channelKey: 'msg_channel',
            title: appTitle,
            body: 'vous aves des nouveaux messages ...',
            notificationLayout: NotificationLayout.BigText));

Future<void> createAnnounceNotification() async =>
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: idAnnounce,
            channelKey: 'annonce_channel',
            title: appTitle,
            body: 'Nouvelle Annonces',
            notificationLayout: NotificationLayout.BigText));

Future<void> createUploadNotification(String notifTitle) async =>
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: idUpload,
            progress: 5,
            channelKey: 'upload_Image_channel',
            title: appTitle,
            body: notifTitle, //'En cours de chargement des images ...'
            notificationLayout: NotificationLayout.BigText));

Future<void> cancelMessageNotification() async =>
    await AwesomeNotifications().cancel(idMessage);

Future<void> cancelAnnounceNotification() async =>
    await AwesomeNotifications().cancel(idAnnounce);

Future<void> cancelUploadNotification() async =>
    await AwesomeNotifications().cancel(idUpload);
