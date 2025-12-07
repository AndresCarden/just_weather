import 'package:flutter/material.dart';
import 'skeleton_box.dart';

class WeatherSkeleton extends StatelessWidget {
  const WeatherSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonBox(width: 120, height: 24),
                      SizedBox(height: 8),
                      SkeletonBox(width: 80, height: 16),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    SkeletonBox(width: 32, height: 24, borderRadius: 16),
                    SizedBox(width: 8),
                    SkeletonBox(width: 32, height: 24, borderRadius: 16),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),
            const SkeletonBox(width: 160, height: 48),
            const SizedBox(height: 8),
            const SkeletonBox(width: 120, height: 20),
            const SizedBox(height: 24),
            const SkeletonBox(width: 140, height: 20),
            const SizedBox(height: 12),
            Row(
              children: const [
                Expanded(child: _SkeletonMetricCard()),
                SizedBox(width: 8),
                Expanded(child: _SkeletonMetricCard()),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Expanded(child: _SkeletonMetricCard()),
                SizedBox(width: 8),
                Expanded(child: _SkeletonMetricCard()),
              ],
            ),

            const SizedBox(height: 24),
            const SkeletonBox(width: 160, height: 20),
            const SizedBox(height: 12),
            SizedBox(
              height: 110,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 8,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return const _SkeletonHourlyCard();
                },
              ),
            ),

            const SizedBox(height: 24),
            const SkeletonBox(width: 170, height: 20),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.2,
              children: List.generate(6, (_) => const _SkeletonDetailCard()),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonMetricCard extends StatelessWidget {
  const _SkeletonMetricCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SkeletonBox(width: 80, height: 14),
          SkeletonBox(width: 60, height: 20),
          SkeletonBox(width: 100, height: 12),
        ],
      ),
    );
  }
}

class _SkeletonHourlyCard extends StatelessWidget {
  const _SkeletonHourlyCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SkeletonBox(width: 40, height: 12),
          SkeletonBox(width: 32, height: 32, borderRadius: 16),
          SkeletonBox(width: 40, height: 12),
        ],
      ),
    );
  }
}

class _SkeletonDetailCard extends StatelessWidget {
  const _SkeletonDetailCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SkeletonBox(width: 90, height: 14),
          SkeletonBox(width: 60, height: 18),
        ],
      ),
    );
  }
}
