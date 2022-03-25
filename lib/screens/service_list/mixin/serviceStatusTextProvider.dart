import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:darkpanda_flutter/enums/service_status.dart';

typedef TextProvider = String Function(BuildContext);

mixin ServiceStatusTextProvider {
  final Map<String, TextProvider> serviceStatusContentMap = {
    ServiceStatus.canceled.name: (context) =>
        AppLocalizations.of(context).serviceCanceled,
    ServiceStatus.completed.name: (context) =>
        AppLocalizations.of(context).serviceCompleted,
    ServiceStatus.expired.name: (context) =>
        AppLocalizations.of(context).serviceExpired,
    ServiceStatus.payment_failed.name: (context) =>
        AppLocalizations.of(context).serviceFailed,
  };

// TODO: Handle cases where service status does not exist in the map.
  Text geTextByServiceStatus(BuildContext context, String serviceStatus) {
    String content = serviceStatusContentMap[serviceStatus](context);

    Color color = Colors.white;
    if (serviceStatus == ServiceStatus.canceled.name ||
        serviceStatus == ServiceStatus.expired.name ||
        serviceStatus == ServiceStatus.payment_failed.name) {
      color = Colors.red;
    }

    return Text(
      content,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: color,
      ),
    );
  }
}
