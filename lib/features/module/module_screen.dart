import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/content/content_bloc.dart';
import '../../blocs/content/content_state.dart';
import '../../blocs/premium/premium_bloc.dart';
import '../../blocs/premium/premium_state.dart';
import '../../blocs/progress/progress_bloc.dart';
import '../../blocs/progress/progress_state.dart';
import '../../core/widgets/lesson_item_tile.dart';
import '../../data/models/module.dart';
import '../paywall/paywall_sheet.dart';

class ModuleScreen extends StatelessWidget {
  const ModuleScreen({super.key, required this.moduleKey});

  final String moduleKey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContentBloc, ContentState>(
      builder: (context, contentState) {
        final module = contentState.modules.firstWhere(
          (item) => item.key == moduleKey,
          orElse: () => const Module(
            key: '',
            title: '',
            subtitle: '',
            colorValue: 0,
            items: [],
            isPremiumModule: false,
          ),
        );

        if (module.key.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('Module not found')),
          );
        }

        return BlocBuilder<PremiumBloc, PremiumState>(
          builder: (context, premiumState) {
            return BlocBuilder<ProgressBloc, ProgressState>(
              builder: (context, progressState) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(module.title),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(16),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final crossAxisCount = constraints.maxWidth > 700 ? 4 : 2;
                        return GridView.builder(
                          itemCount: module.items.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                          ),
                          itemBuilder: (context, index) {
                            final item = module.items[index];
                            final locked = item.isPremium && !premiumState.settings.isPremium;
                            final completed =
                                progressState.entries.containsKey('${module.key}_${item.key}');
                            return LessonItemTile(
                              title: item.title,
                              subtitle: item.subtitle,
                              locked: locked,
                              completed: completed,
                              onTap: () {
                                if (locked) {
                                  showModalBottomSheet(
                                    context: context,
                                    showDragHandle: true,
                                    builder: (context) => const PaywallSheet(),
                                  );
                                } else {
                                  context.go('/lesson/${module.key}/${item.key}');
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
