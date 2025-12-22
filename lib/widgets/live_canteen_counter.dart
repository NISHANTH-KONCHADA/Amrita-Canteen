import 'package:flutter/material.dart';
import '../data/order_store.dart';

class LiveCanteenCounter extends StatelessWidget {
  const LiveCanteenCounter({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: MediaQuery.of(context).padding.bottom + 72,
      child: ValueListenableBuilder<int>(
        valueListenable: OrderStore.canteenCount,
        builder: (_, count, __) {
          return Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFF8B0037),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.groups,
                      color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    count.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
