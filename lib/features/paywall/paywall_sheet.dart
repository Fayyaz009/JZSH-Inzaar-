import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/premium/premium_bloc.dart';
import '../../blocs/premium/premium_event.dart';

class PaywallSheet extends StatelessWidget {
  const PaywallSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Go Premium', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          const Text('Unlock all lessons, games, and rhymes!'),
          const SizedBox(height: 12),
          const _PlanTile(title: 'Monthly', price: '\$9.99'),
          const _PlanTile(title: 'Yearly', price: '\$59.99'),
          const _PlanTile(title: 'Lifetime', price: '\$199.99'),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.read<PremiumBloc>().add(const UnlockPremium());
                Navigator.pop(context);
              },
              child: const Text('Continue'),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Billing is mocked for MVP. Google Play Billing can replace this later.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _PlanTile extends StatelessWidget {
  const _PlanTile({required this.title, required this.price});

  final String title;
  final String price;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      trailing: Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
