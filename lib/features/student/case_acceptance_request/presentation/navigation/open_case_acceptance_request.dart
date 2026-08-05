import 'package:flutter/material.dart';
import '../models/case_acceptance_request_args.dart';
import '../screens/case_acceptance_request_screen.dart';

void openCaseAcceptanceRequest(
  BuildContext context,
  CaseAcceptanceRequestArgs args,
) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => CaseAcceptanceRequestScreen(args: args),
    ),
  );
}