import 'package:flutter/material.dart';
import 'package:manshan/core/extra/grant_extra.dart';

class GrantEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;

  const GrantEmptyState({
    super.key,
    this.title = 'No accesses granted',
    this.subtitle = 'Select a user above and tap Grant to share access with them.',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: GrantColors.primaryDim,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shield_outlined,
                color: GrantColors.primary,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(title, style: GrantTextStyles.emptyTitle),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: GrantTextStyles.emptySubtitle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}