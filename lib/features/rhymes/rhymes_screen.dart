import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/content/content_bloc.dart';
import '../../blocs/content/content_state.dart';
import '../../blocs/premium/premium_bloc.dart';
import '../../blocs/premium/premium_state.dart';
import '../paywall/paywall_sheet.dart';

class RhymesScreen extends StatefulWidget {
  const RhymesScreen({super.key});

  @override
  State<RhymesScreen> createState() => _RhymesScreenState();
}

class _RhymesScreenState extends State<RhymesScreen> {
  final AudioPlayer _player = AudioPlayer();
  String _playingKey = '';

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _playingKey = '';
        });
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlay(String key, String path) async {
    try {
      if (_playingKey == key) {
        await _player.stop();
        setState(() {
          _playingKey = '';
        });
      } else {
        await _player.stop();
        await _player.play(AssetSource(path.replaceFirst('assets/', '')));
        setState(() {
          _playingKey = key;
        });
      }
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
        return BlocBuilder<PremiumBloc, PremiumState>(
          builder: (context, premiumState) {
            return Scaffold(
              appBar: AppBar(title: const Text('Rhymes')),
              body: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final rhyme = contentState.rhymes[index];
                  final locked = rhyme.isPremium && !premiumState.settings.isPremium;
                  return ListTile(
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: Text(rhyme.title),
                    leading: Icon(locked ? Icons.lock : Icons.music_note),
                    trailing: locked
                        ? ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                showDragHandle: true,
                                builder: (context) => const PaywallSheet(),
                              );
                            },
                            child: const Text('Unlock'),
                          )
                        : IconButton(
                            icon: Icon(
                              _playingKey == rhyme.key ? Icons.pause_circle : Icons.play_circle,
                            ),
                            onPressed: () => _togglePlay(rhyme.key, rhyme.audioPath),
                          ),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: contentState.rhymes.length,
              ),
            );
          },
        );
      },
    );
  }
}
