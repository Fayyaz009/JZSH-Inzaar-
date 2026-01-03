import '../../data/models/lesson_item.dart';

class ContentBuilder {
  static const _alphabetImage = 'assets/images/alphabet/placeholder.png';
  static const _numbersImage = 'assets/images/numbers/placeholder.png';
  static const _colorsImage = 'assets/images/colors/placeholder.png';
  static const _shapesImage = 'assets/images/shapes/placeholder.png';
  static const _animalsImage = 'assets/images/animals/placeholder.png';
  static const _foodsImage = 'assets/images/foods/placeholder.png';
  static const _placeholderAudio = 'assets/audio/pronunciations/placeholder.wav';

  static List<LessonItem> buildAlphabetItems() {
    return List.generate(26, (index) {
      final letter = String.fromCharCode('A'.codeUnitAt(0) + index);
      final isPremium = index >= 5;
      return LessonItem(
        key: letter,
        title: letter,
        subtitle: '${letter} is for ${_alphabetWord(letter)}',
        imagePath: _alphabetImage,
        audioPath: _placeholderAudio,
        isPremium: isPremium,
      );
    });
  }

  static List<LessonItem> buildNumberItems() {
    return List.generate(20, (index) {
      final number = index + 1;
      final isPremium = number > 5;
      return LessonItem(
        key: number.toString(),
        title: number.toString(),
        subtitle: 'Count $number',
        imagePath: _numbersImage,
        audioPath: _placeholderAudio,
        isPremium: isPremium,
      );
    });
  }

  static List<LessonItem> buildColorItems() {
    final colors = [
      'Red',
      'Blue',
      'Green',
      'Yellow',
      'Orange',
      'Purple',
      'Pink',
      'Brown',
    ];
    return colors
        .map((color) => LessonItem(
              key: color.toLowerCase(),
              title: color,
              subtitle: 'Find $color',
              imagePath: _colorsImage,
              audioPath: _placeholderAudio,
              isPremium: true,
            ))
        .toList();
  }

  static List<LessonItem> buildShapeItems() {
    final shapes = ['Circle', 'Square', 'Triangle', 'Rectangle', 'Star', 'Heart'];
    return shapes
        .map((shape) => LessonItem(
              key: shape.toLowerCase(),
              title: shape,
              subtitle: 'Spot a $shape',
              imagePath: _shapesImage,
              audioPath: _placeholderAudio,
              isPremium: true,
            ))
        .toList();
  }

  static List<LessonItem> buildAnimalItems() {
    final animals = [
      'Lion',
      'Elephant',
      'Giraffe',
      'Zebra',
      'Monkey',
      'Panda',
      'Tiger',
      'Bear',
      'Dog',
      'Cat',
    ];
    return animals
        .map((animal) => LessonItem(
              key: animal.toLowerCase(),
              title: animal,
              subtitle: 'Meet the $animal',
              imagePath: _animalsImage,
              audioPath: _placeholderAudio,
              isPremium: true,
            ))
        .toList();
  }

  static List<LessonItem> buildFoodItems() {
    final foods = [
      'Apple',
      'Banana',
      'Carrot',
      'Tomato',
      'Bread',
      'Cheese',
      'Milk',
      'Egg',
      'Rice',
      'Grapes',
    ];
    return foods
        .map((food) => LessonItem(
              key: food.toLowerCase(),
              title: food,
              subtitle: 'Yummy $food',
              imagePath: _foodsImage,
              audioPath: _placeholderAudio,
              isPremium: true,
            ))
        .toList();
  }

  static String _alphabetWord(String letter) {
    const map = {
      'A': 'Apple',
      'B': 'Ball',
      'C': 'Cat',
      'D': 'Dog',
      'E': 'Elephant',
      'F': 'Fish',
      'G': 'Giraffe',
      'H': 'Hat',
      'I': 'Ice cream',
      'J': 'Juice',
      'K': 'Kite',
      'L': 'Lion',
      'M': 'Moon',
      'N': 'Nest',
      'O': 'Octopus',
      'P': 'Penguin',
      'Q': 'Queen',
      'R': 'Rainbow',
      'S': 'Sun',
      'T': 'Tiger',
      'U': 'Umbrella',
      'V': 'Violin',
      'W': 'Whale',
      'X': 'Xylophone',
      'Y': 'Yogurt',
      'Z': 'Zebra',
    };
    return map[letter] ?? letter;
  }
}
