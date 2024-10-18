import 'package:flutter/material.dart';

class RoleBasedWidget extends StatelessWidget {
  final String userRole;
  final List<String> allowedRoles;
  final Widget child;
  final Widget fallback;

  const RoleBasedWidget({
    super.key,
    required this.userRole,
    required this.allowedRoles,
    required this.child,
    this.fallback = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context) {
    return allowedRoles.contains(userRole) ? child : fallback;
  }
}
