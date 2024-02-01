import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'alert',
          channelKey: 'Alerts',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
        )
      ],
      debug: true);
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/second": (context) => const NotificationSite(),
        "/third": (context) => const NotificationSite2(),
      },
      navigatorKey: navigatorKey,
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  AwesomeNotifications()
                      .isNotificationAllowed()
                      .then((isAllowed) {
                    AwesomeNotifications().createNotification(
                        content: NotificationContent(
                          id: 10,
                          channelKey: 'Alerts',
                          actionType: ActionType.Default,
                          title: 'Hello World!',
                          body: 'This is my first notification!',
                        ),
                        actionButtons: [
                          NotificationActionButton(
                            key: "Alerts",
                            label: "Dismiss",
                            actionType: ActionType.DismissAction,
                          )
                        ]);

                    if (!isAllowed) {
                      AwesomeNotifications()
                          .requestPermissionToSendNotifications();
                    }
                  });
                },
                child: const Text("Send Notification"))
          ],
        )),
      ),
    );
  }
}

class NotificationController {
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint("created");
  }

  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint("Displayed");
  }

  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    navigatorKey.currentState?.pushNamed("/third");
    debugPrint("Dismiss");
  }

  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    debugPrint("Test");
    navigatorKey.currentState?.pushNamed("/second");
  }
}

class NotificationSite extends StatelessWidget {
  const NotificationSite({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.green,
    );
  }
}

class NotificationSite2 extends StatelessWidget {
  const NotificationSite2({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.red,
    );
  }
}
