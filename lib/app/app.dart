import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'router.dart';

class MobilityPlusApp extends StatelessWidget {
  const MobilityPlusApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'Mobility+',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    routerConfig: appRouter,
  );
}
