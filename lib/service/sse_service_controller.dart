import 'dart:async';
import 'dart:developer';
import 'package:b2c/service/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/utils/shar_preferences.dart';

class SSEService extends GetxController with WidgetsBindingObserver {
  Stream<SSEModel>? sseStream;
  StreamSubscription<SSEModel>? _sseSubscription;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    connectSSE();
  }

  void connectSSE() async {
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? '';
    String supplierId =
        await SharPreferences.getString(SharPreferences.supplierId) ?? '';

    log("Returning from SSEService since userid is empty...");

    if (userId.isEmpty) {
      return;
    }

    log("Connecting to SSEService... ${"http://45.127.101.159:9090/sse/stream/$supplierId?userId=$userId"}");

    sseStream = SSEClient.subscribeToSSE(
      url:
          'http://45.127.101.159:9090/sse/stream/AL-S202309-756?userId=$userId',
      header: {},
    );

    _sseSubscription = sseStream!.listen((SSEModel event) {
      log("Listening to SSEService...$event");
      if (event.data != null) {
        log("SSEService Message Received: ${event.data}");

        // Show notification with SSE data
        NotificationService.instance.showNotification(event.data!);
      }
    }, onError: (error) {
      log("SSEService Error: $error");
      reconnectSSE();
    });
  }

  void disconnectSSE() {
    log("SSEService: Disconnecting stream.");
    _sseSubscription?.cancel(); // Cancel the SSE stream
    _sseSubscription = null;
    sseStream = null;
  }

  void reconnectSSE() {
    Future.delayed(const Duration(seconds: 3), () {
      log("Reconnecting to SSEService...");
      connectSSE();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      log("App Resumed: Reconnecting SSEService...");
      // connectSSE();
    } else if (state == AppLifecycleState.paused) {
      log("App Paused: SSEService Disconnected");
    }
  }

  @override
  void onClose() {
    disconnectSSE();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }
}
