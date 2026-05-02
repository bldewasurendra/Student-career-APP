class GuideItem {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String category;
  final String content;

  GuideItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
    required this.content,
  });
}

class LearningResource {
  final String id;
  final String title;
  final String videoUrl;
  final String thumbnailUrl;
  final String duration;

  LearningResource({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.duration,
  });
}

class JobModel {
  final String id;
  final String title;
  final String company;
  final String location;
  final String salary;
  final String logoUrl;
  final String type;
  final String postedDate;
  final String description;

  JobModel({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.logoUrl,
    required this.type,
    required this.postedDate,
    required this.description,
  });
}

class ProgramModel {
  final String id;
  final String title;
  final String university;
  final String country;
  final String imageUrl;
  final String duration;
  final String cost;
  final String requirements;
  final String description;

  ProgramModel({
    required this.id,
    required this.title,
    required this.university,
    required this.country,
    required this.imageUrl,
    required this.duration,
    required this.cost,
    required this.requirements,
    required this.description,
  });
}


