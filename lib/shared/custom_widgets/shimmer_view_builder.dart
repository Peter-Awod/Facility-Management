// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerViewBuilder extends StatelessWidget {
  const ShimmerViewBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Shimmer.fromColors(
            baseColor: Colors.blueGrey.shade200,
            highlightColor: Colors.blueGrey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User widget
                const SizedBox(
                  height: 16,
                ),
                Container(
                  height: 28,
                  width: 300,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: Colors.blueGrey,
                  ),
                ),
                // User widget
                const SizedBox(
                  height: 16,
                ),

                Container(
                  height: 80,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: Colors.blueGrey,
                  ),
                ),
                // leading post widget
                const SizedBox(height: 8),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: Colors.blueGrey,
                  ),
                  height: 20,
                  width: 240,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
