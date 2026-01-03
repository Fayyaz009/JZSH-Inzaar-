import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/content/content_bloc.dart';
import '../../blocs/content/content_state.dart';
import '../../blocs/premium/premium_bloc.dart';
import '../../blocs/premium/premium_event.dart';
import '../../blocs/premium/premium_state.dart';
import '../../blocs/progress/progress_bloc.dart';
import '../../blocs/progress/progress_event.dart';
import '../../blocs/progress/progress_state.dart';

class ParentScreen extends StatefulWidget {
  const ParentScreen({super.key});

  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  bool _unlocked = false;
  Timer? _longPressTimer;

  @override
  void dispose() {
    _longPressTimer?.cancel();
    super.dispose();
  }

  void _startLongPress() {
    _longPressTimer?.cancel();
    _longPressTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _unlocked = true;
        });
      }
    });
  }

  void _cancelLongPress() {
    _longPressTimer?.cancel();
  }

  Future<void> _showMathChallenge() async {
    final controller = TextEditingController();
    final isCorrect = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Parent Check'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Solve: 3 + 4 = ?'),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, controller.text.trim() == '7');
              },
              child: const Text('Unlock'),
            ),
          ],
        );
      },
    );
    if (isCorrect == true) {
      setState(() {
        _unlocked = true;
      });
    } else if (isCorrect == false) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Oops, try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PremiumBloc, PremiumState>(
      builder: (context, premiumState) {
        return BlocBuilder<ProgressBloc, ProgressState>(
          builder: (context, progressState) {
            return BlocBuilder<ContentBloc, ContentState>(
              builder: (context, contentState) {
                return Scaffold(
                  appBar: AppBar(title: const Text('Parent Dashboard')),
                  body: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _unlocked
                        ? _buildDashboard(context, premiumState, progressState, contentState)
                        : _buildLockedView(context),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildLockedView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock, size: 80, color: Colors.redAccent),
          const SizedBox(height: 12),
          const Text('Parents only', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 16),
          GestureDetector(
            onLongPressStart: (_) => _startLongPress(),
            onLongPressEnd: (_) => _cancelLongPress(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Hold for 3 seconds',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _showMathChallenge,
            child: const Text('Solve a quick math challenge'),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(
    BuildContext context,
    PremiumState premiumState,
    ProgressState progressState,
    ContentState contentState,
  ) {
    final moduleProgress = contentState.modules.map((module) {
      final total = module.items.length;
      final completed = module.items
          .where((item) => progressState.entries.containsKey('${module.key}_${item.key}'))
          .length;
      return {'title': module.title, 'completed': completed, 'total': total};
    }).toList();

    return ListView(
      children: [
        Card(
          child: ListTile(
            title: const Text('Premium Status'),
            subtitle: Text(premiumState.settings.isPremium ? 'Active' : 'Free'),
            trailing: premiumState.settings.isPremium
                ? const Icon(Icons.verified, color: Colors.green)
                : const Icon(Icons.lock_outline, color: Colors.redAccent),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: SwitchListTile(
            value: premiumState.settings.musicOn,
            onChanged: (_) => context.read<PremiumBloc>().add(const ToggleMusic()),
            title: const Text('Music'),
          ),
        ),
        Card(
          child: SwitchListTile(
            value: premiumState.settings.sfxOn,
            onChanged: (_) => context.read<PremiumBloc>().add(const ToggleSfx()),
            title: const Text('Sound Effects'),
          ),
        ),
        const SizedBox(height: 12),
        Text('Progress Summary', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        ...moduleProgress.map(
          (progress) => ListTile(
            title: Text(progress['title'] as String),
            subtitle: Text(
              '${progress['completed']} of ${progress['total']} completed',
            ),
            leading: const Icon(Icons.stars),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () => context.read<PremiumBloc>().add(const RestorePurchase()),
          icon: const Icon(Icons.restore),
          label: const Text('Restore Purchase (Mock)'),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () => context.read<PremiumBloc>().add(const UnlockPremium()),
          icon: const Icon(Icons.workspace_premium),
          label: const Text('Unlock Premium (Mock)'),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () => context.read<ProgressBloc>().add(const ResetProgress()),
          icon: const Icon(Icons.restart_alt),
          label: const Text('Reset Progress'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Thanks for rating us!')),
            );
          },
          icon: const Icon(Icons.star_rate),
          label: const Text('Rate App'),
        ),
      ],
    );
  }
}
