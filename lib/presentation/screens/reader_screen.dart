import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/highlight.dart';
import '../blocs/reader/reader_bloc.dart';
import '../widgets/reader_settings_sheet.dart';
import '../widgets/reader_theme.dart';
import '../widgets/highlight_actions_sheet.dart';
import '../widgets/highlighted_text.dart';

class ReaderScreen extends StatefulWidget {
  final String bookId;
  final int? highlightId;

  const ReaderScreen({super.key, required this.bookId, this.highlightId});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  late final ScrollController _controller;
  TextSelection? _selection;
  bool _controlsVisible = true;
  bool _initialJumpDone = false;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    context.read<ReaderBloc>().add(ReaderOpened(widget.bookId));
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    if (_controller.position.hasPixels) {
      final max = max(_controller.position.maxScrollExtent, 1);
      final percent = (_controller.offset / max).clamp(0, 1).toDouble();
      context.read<ReaderBloc>().add(ReaderScrollPositionChanged(_controller.offset, percent));
    }
  }

  void _toggleControls() {
    setState(() => _controlsVisible = !_controlsVisible);
  }

  Future<void> _showSettings(BuildContext context, ReaderReady state) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => ReaderSettingsSheet(state: state),
    );
  }

  Future<void> _showHighlightActions(BuildContext context, ReaderReady state) async {
    final selection = _selection;
    if (selection == null || selection.isCollapsed) return;
    final start = selection.start;
    final end = selection.end;
    final text = state.book.content.substring(start, end);
    await showModalBottomSheet(
      context: context,
      builder: (_) => HighlightActionsSheet(
        onCopy: () {
          Clipboard.setData(ClipboardData(text: text));
          Navigator.of(context).pop();
        },
        onColorSelected: (colorHex) {
          context.read<ReaderBloc>().add(
                ReaderHighlightAdded(
                  startIndex: start,
                  endIndex: end,
                  text: text,
                  colorHex: colorHex,
                ),
              );
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _jumpToOffset(double offset) {
    if (!_controller.hasClients) return;
    _controller.jumpTo(offset.clamp(0, _controller.position.maxScrollExtent));
  }

  void _jumpToHighlight(ReaderReady state, int highlightId) {
    if (state.highlights.isEmpty || !_controller.hasClients) return;
    final highlight = state.highlights.firstWhere(
      (h) => h.id == highlightId,
      orElse: () => state.highlights.first,
    );
    final ratio = highlight.startIndex / max(1, state.book.content.length);
    final target = ratio * _controller.position.maxScrollExtent;
    _jumpToOffset(target);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReaderBloc, ReaderState>(
      listener: (context, state) {
        if (state is ReaderReady && !_initialJumpDone) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (state.scrollOffset > 0) {
              _jumpToOffset(state.scrollOffset);
            }
            if (widget.highlightId != null) {
              context.read<ReaderBloc>().add(ReaderJumpToHighlightRequested(widget.highlightId!));
            }
            _initialJumpDone = true;
          });
        }
        if (state is ReaderReady && state.pendingJumpHighlightId != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _jumpToHighlight(state, state.pendingJumpHighlightId!);
            context.read<ReaderBloc>().add(ReaderJumpToSavedPositionRequested());
          });
        }
      },
      builder: (context, state) {
        if (state is ReaderLoading || state is ReaderInitial) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (state is ReaderError) {
          return Scaffold(body: Center(child: Text(state.message)));
        }
        if (state is! ReaderReady) {
          return const SizedBox.shrink();
        }
        final theme = ReaderTheme.fromMode(state.themeMode);
        return Scaffold(
          backgroundColor: theme.background,
          appBar: _controlsVisible
              ? AppBar(
                  backgroundColor: theme.background,
                  title: Text(state.book.title, style: TextStyle(color: theme.text)),
                  iconTheme: IconThemeData(color: theme.text),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.tune, color: theme.text),
                      onPressed: () => _showSettings(context, state),
                    ),
                  ],
                )
              : null,
          floatingActionButton: _selection == null || _selection!.isCollapsed
              ? null
              : FloatingActionButton.extended(
                  onPressed: () => _showHighlightActions(context, state),
                  label: const Text('Highlight'),
                  icon: const Icon(Icons.highlight_rounded),
                ),
          body: GestureDetector(
            onTap: _toggleControls,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: SelectionArea(
                  child: HighlightedText(
                    content: state.book.content,
                    highlights: state.highlights,
                    textStyle: TextStyle(
                      fontSize: state.typographySettings.fontSize,
                      height: state.typographySettings.lineHeight,
                      fontFamily: state.typographySettings.fontFamily,
                      color: theme.text,
                    ),
                    paragraphSpacing: state.typographySettings.paragraphSpacing,
                    onSelectionChanged: (selection) {
                      setState(() => _selection = selection);
                    },
                    scrollController: _controller,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
