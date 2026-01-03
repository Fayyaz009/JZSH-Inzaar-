import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/premium/premium_bloc.dart';
import '../../blocs/premium/premium_state.dart';
import '../paywall/paywall_sheet.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  final List<Map<String, String>> _matches = const [
    {'letter': 'A', 'word': 'Apple'},
    {'letter': 'B', 'word': 'Ball'},
    {'letter': 'C', 'word': 'Cat'},
    {'letter': 'D', 'word': 'Dog'},
    {'letter': 'E', 'word': 'Elephant'},
  ];

  int _matchIndex = 0;
  String _selectedWord = '';
  int _countTarget = 3;
  int _countGuess = 0;
  bool _showReward = false;

  void _nextMatch() {
    setState(() {
      _matchIndex = (_matchIndex + 1) % _matches.length;
      _selectedWord = '';
      _showReward = false;
    });
  }

  void _resetCountGame() {
    final random = Random();
    setState(() {
      _countTarget = random.nextInt(5) + 1;
      _countGuess = 0;
      _showReward = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _resetCountGame();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PremiumBloc, PremiumState>(
      builder: (context, premiumState) {
        final isPremium = premiumState.settings.isPremium;
        final match = _matches[_matchIndex];
        final options = _matches.map((item) => item['word']!).toList();
        return Scaffold(
          appBar: AppBar(title: const Text('Games')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text(
                  'Game 1: Match the Letter',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'Find the word for ${match['letter']}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: options
                              .map(
                                (word) => ChoiceChip(
                                  label: Text(word),
                                  selected: _selectedWord == word,
                                  onSelected: (_) {
                                    setState(() {
                                      _selectedWord = word;
                                      _showReward = word == match['word'];
                                    });
                                  },
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 12),
                        if (_showReward)
                          const Text('⭐ Great Job!', style: TextStyle(fontSize: 20)),
                        TextButton(
                          onPressed: _nextMatch,
                          child: const Text('Next Round'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Game 2: Count the Objects',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        if (!isPremium)
                          Column(
                            children: [
                              const Icon(Icons.lock, size: 48, color: Colors.redAccent),
                              const SizedBox(height: 8),
                              const Text('Unlock premium to play the full game!'),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    showDragHandle: true,
                                    builder: (context) => const PaywallSheet(),
                                  );
                                },
                                child: const Text('See Plans'),
                              ),
                            ],
                          )
                        else
                          Column(
                            children: [
                              Text(
                                'Tap ${_countTarget} stars',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                children: List.generate(
                                  _countTarget + 2,
                                  (index) => IconButton(
                                    icon: Icon(
                                      Icons.star,
                                      color: _countGuess > index ? Colors.amber : Colors.grey,
                                    ),
                                    onPressed: () {
                                      if (_countGuess <= index) {
                                        setState(() {
                                          _countGuess = index + 1;
                                          if (_countGuess == _countTarget) {
                                            _showReward = true;
                                          }
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (_showReward)
                                const Text('🎉 You counted them all!', style: TextStyle(fontSize: 20)),
                              TextButton(
                                onPressed: _resetCountGame,
                                child: const Text('Play Again'),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
