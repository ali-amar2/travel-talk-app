class Destination {
  final String title;
  final String subtitle;
  final String imagePath;
  final double rating;
  final String location;
  final String description;
  final List<String> highlights;
  final String bestTimeToVisit;

  const Destination({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.rating,
    required this.location,
    required this.description,
    required this.highlights,
    required this.bestTimeToVisit,
  });
}
