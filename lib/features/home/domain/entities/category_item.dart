class CategoryItem {
  final String title;
  final String emoji;
  final bool isSelected;

  const CategoryItem({
    required this.title,
    required this.emoji,
    this.isSelected = false,
  });

  CategoryItem copyWith({String? title, String? emoji, bool? isSelected}) {
    return CategoryItem(
      title: title ?? this.title,
      emoji: emoji ?? this.emoji,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
