import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/content/content_bloc.dart';
import '../../blocs/content/content_state.dart';
import '../../blocs/premium/premium_bloc.dart';
import '../../blocs/premium/premium_state.dart';
import '../../blocs/progress/progress_bloc.dart';
import '../../blocs/progress/progress_event.dart';
import '../../data/models/lesson_item.dart';
import '../../data/models/module.dart';
import '../paywall/paywall_sheet.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({
    super.key,
    required this.moduleKey,
    required this.itemKey,
  });

  final String moduleKey;
  final String itemKey;

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  late final AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _tapped = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio(String path) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(path.replaceFirst('assets/', '')));
      setState(() {
        _isPlaying = true;
      });
      _audioPlayer.onPlayerComplete.listen((event) {
        if (mounted) {
          setState(() {
            _isPlaying = false;
          });
        }
      });
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Audio not available.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContentBloc, ContentState>(
      builder: (context, contentState) {
        final module = contentState.modules.firstWhere(
          (item) => item.key == widget.moduleKey,
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
            body: Center(child: Text('Lesson not found')),
          );
        }
        final lesson = module.items.firstWhere(
          (item) => item.key == widget.itemKey,
          orElse: () => const LessonItem(
            key: '',
            title: '',
            subtitle: '',
            imagePath: '',
            audioPath: '',
            isPremium: false,
          ),
        );
        if (lesson.key.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('Lesson not found')),
          );
        }

        return BlocBuilder<PremiumBloc, PremiumState>(
          builder: (context, premiumState) {
            return Scaffold(
              appBar: AppBar(
                title: Text('${module.title} Lesson'),
              ),
              body: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      lesson.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      lesson.subtitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _tapped = !_tapped;
                          });
                        },
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 200),
                          scale: _tapped ? 1.05 : 1.0,
                          child: Image.asset(
                            lesson.imagePath,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image_not_supported, size: 72),
                                  SizedBox(height: 8),
                                  Text('Image coming soon!'),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _playAudio(lesson.audioPath),
                          icon: Icon(_isPlaying ? Icons.stop : Icons.volume_up),
                          label: Text(_isPlaying ? 'Playing' : 'Play'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<ProgressBloc>().add(
                                  MarkItemCompleted(
                                    moduleKey: module.key,
                                    itemKey: lesson.key,
                                  ),
                                );
                            final nextIndex =
                                module.items.indexWhere((item) => item.key == lesson.key) + 1;
                            if (nextIndex >= module.items.length) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Great job! You finished this module.')),
                              );
                              return;
                            }
                            final nextItem = module.items[nextIndex];
                            final locked = nextItem.isPremium && !premiumState.settings.isPremium;
                            if (locked) {
                              showModalBottomSheet(
                                context: context,
                                showDragHandle: true,
                                builder: (context) => const PaywallSheet(),
                              );
                            } else {
                              context.go('/lesson/${module.key}/${nextItem.key}');
                            }
                          },
                          child: const Text('Next'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
