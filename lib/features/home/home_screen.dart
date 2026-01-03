import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/content/content_bloc.dart';
import '../../blocs/content/content_state.dart';
import '../../core/widgets/kid_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContentBloc, ContentState>(
      builder: (context, state) {
        final modules = state.modules;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Learning Home'),
            actions: [
              IconButton(
                onPressed: () => context.go('/parent'),
                icon: const Icon(Icons.lock),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 700 ? 4 : 2;
                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 1.1,
                  children: [
                    ...modules.map(
                      (module) => KidCard(
                        title: module.title,
                        subtitle: module.subtitle,
                        color: Color(module.colorValue),
                        icon: Icons.school,
                        onTap: () => context.go('/module/${module.key}'),
                      ),
                    ),
                    KidCard(
                      title: 'Rhymes',
                      subtitle: 'Sing along',
                      color: const Color(0xFF06D6A0),
                      icon: Icons.music_note,
                      onTap: () => context.go('/rhymes'),
                    ),
                    KidCard(
                      title: 'Games',
                      subtitle: 'Play & learn',
                      color: const Color(0xFF118AB2),
                      icon: Icons.extension,
                      onTap: () => context.go('/games'),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
