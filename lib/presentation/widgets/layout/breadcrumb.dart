import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Breadcrumb extends StatelessWidget {
  final List<BreadcrumbItem> items;

  const Breadcrumb({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) ...[
              Icon(
                Icons.chevron_right,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 8),
            ],
            if (i == items.length - 1)
              // Last item (current page) - not clickable
              Text(
                items[i].label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              )
            else
              // Clickable breadcrumb item
              InkWell(
                onTap: () {
                  if (items[i].route != null) {
                    Get.toNamed(items[i].route!);
                  }
                },
                child: Text(
                  items[i].label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                      ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class BreadcrumbItem {
  final String label;
  final String? route;

  BreadcrumbItem({
    required this.label,
    this.route,
  });
}

