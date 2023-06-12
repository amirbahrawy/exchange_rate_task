import 'dart:developer';

import '../../core/exceptions/redundant_request_exception.dart';
import 'package:flutter/material.dart';

import '../res/app_colors.dart';

void showSnackBar(
  BuildContext context, {
  required dynamic message,
  Widget? action,
  EdgeInsetsGeometry? margin = const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 32.0),
}) {
  if (message is RedundantRequestException) return log(message.toString());

  final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
  if (scaffoldMessenger == null) return;

  scaffoldMessenger.clearSnackBars();

  message = message.toString();

  const snackBarDuration = Duration(seconds: 4);

  final snackBar = SnackBar(
      duration: snackBarDuration,
      margin: margin,
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.ACCENT_COLOR,
      content: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                (message as String),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: AppColors.TEXT_LIGHT),
              ),
            ),
            if (action != null) action,
          ],
        ),
      ));

  scaffoldMessenger.showSnackBar(snackBar);
}
