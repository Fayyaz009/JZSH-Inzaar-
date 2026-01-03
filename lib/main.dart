import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/router.dart';
import 'app/theme.dart';
import 'blocs/content/content_bloc.dart';
import 'blocs/premium/premium_bloc.dart';
import 'blocs/progress/progress_bloc.dart';
import 'core/db/app_database.dart';
import 'data/repositories/content_repository.dart';
import 'data/repositories/premium_repository.dart';
import 'data/repositories/progress_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase.instance.initialize();

  final contentRepository = ContentRepository();
  final premiumRepository = PremiumRepository(database: AppDatabase.instance);
  final progressRepository = ProgressRepository(database: AppDatabase.instance);

  runApp(KidsLearningApp(
    contentRepository: contentRepository,
    premiumRepository: premiumRepository,
    progressRepository: progressRepository,
  ));
}

class KidsLearningApp extends StatelessWidget {
  const KidsLearningApp({
    super.key,
    required this.contentRepository,
    required this.premiumRepository,
    required this.progressRepository,
  });

  final ContentRepository contentRepository;
  final PremiumRepository premiumRepository;
  final ProgressRepository progressRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: contentRepository),
        RepositoryProvider.value(value: premiumRepository),
        RepositoryProvider.value(value: progressRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ContentBloc(
              contentRepository: contentRepository,
            )..add(const LoadContent()),
          ),
          BlocProvider(
            create: (context) => PremiumBloc(
              premiumRepository: premiumRepository,
            )..add(const LoadPremium()),
          ),
          BlocProvider(
            create: (context) => ProgressBloc(
              progressRepository: progressRepository,
            )..add(const LoadProgress()),
          ),
        ],
        child: MaterialApp.router(
          title: 'Kids Learning',
          theme: buildAppTheme(),
          routerConfig: buildRouter(),
        ),
      ),
    );
  }
}
