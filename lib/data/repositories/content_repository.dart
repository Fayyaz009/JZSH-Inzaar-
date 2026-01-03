import '../../core/utils/content_builder.dart';
import '../models/lesson_item.dart';
import '../models/module.dart';
import '../models/rhyme.dart';

class ContentRepository {
  List<Module> getModules() {
    return [
      Module(
        key: 'alphabet',
        title: 'Alphabet',
        subtitle: 'A to Z',
        colorValue: 0xFFFF8FAB,
        items: ContentBuilder.buildAlphabetItems(),
        isPremiumModule: false,
      ),
      Module(
        key: 'numbers',
        title: 'Numbers',
        subtitle: '1 to 20',
        colorValue: 0xFF6BCB77,
        items: ContentBuilder.buildNumberItems(),
        isPremiumModule: false,
      ),
      Module(
        key: 'colors',
        title: 'Colors',
        subtitle: '8 colors',
        colorValue: 0xFFFFD93D,
        items: ContentBuilder.buildColorItems(),
        isPremiumModule: true,
      ),
      Module(
        key: 'shapes',
        title: 'Shapes',
        subtitle: '6 shapes',
        colorValue: 0xFF4D96FF,
        items: ContentBuilder.buildShapeItems(),
        isPremiumModule: true,
      ),
      Module(
        key: 'animals',
        title: 'Animals',
        subtitle: '10 animals',
        colorValue: 0xFFFFA07A,
        items: ContentBuilder.buildAnimalItems(),
        isPremiumModule: true,
      ),
      Module(
        key: 'foods',
        title: 'Foods',
        subtitle: '10 tasty foods',
        colorValue: 0xFFB5179E,
        items: ContentBuilder.buildFoodItems(),
        isPremiumModule: true,
      ),
    ];
  }

  List<Rhyme> getRhymes() {
    return const [
      Rhyme(
        key: 'twinkle',
        title: 'Twinkle Twinkle',
        audioPath: 'assets/audio/rhymes/placeholder.wav',
        isPremium: false,
      ),
      Rhyme(
        key: 'wheels',
        title: 'Wheels on the Bus',
        audioPath: 'assets/audio/rhymes/placeholder.wav',
        isPremium: true,
      ),
      Rhyme(
        key: 'bingo',
        title: 'Bingo',
        audioPath: 'assets/audio/rhymes/placeholder.wav',
        isPremium: true,
      ),
      Rhyme(
        key: 'star',
        title: 'Star Light',
        audioPath: 'assets/audio/rhymes/placeholder.wav',
        isPremium: true,
      ),
      Rhyme(
        key: 'rain',
        title: 'Rain Rain Go Away',
        audioPath: 'assets/audio/rhymes/placeholder.wav',
        isPremium: true,
      ),
    ];
  }

  LessonItem? getLessonItem(String moduleKey, String itemKey) {
    final module = getModules().firstWhere(
      (module) => module.key == moduleKey,
      orElse: () => Module(
        key: '',
        title: '',
        subtitle: '',
        colorValue: 0,
        items: const [],
        isPremiumModule: false,
      ),
    );
    if (module.key.isEmpty) {
      return null;
    }
    return module.items.firstWhere(
      (item) => item.key == itemKey,
      orElse: () => const LessonItem(
        key: '',
        title: '',
        subtitle: '',
        imagePath: '',
        audioPath: '',
        isPremium: false,
      ),
    );
  }
}
