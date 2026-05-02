class CVData {
  String fullName;
  String email;
  String phone;
  String address;
  String summary;
  List<Education> education;
  List<Experience> experience;
  List<String> skills;

  CVData({
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.address = '',
    this.summary = '',
    List<Education>? education,
    List<Experience>? experience,
    List<String>? skills,
  })  : education = education ?? [],
        experience = experience ?? [],
        skills = skills ?? [];
}

class Education {
  String degree;
  String school;
  String year;

  Education({this.degree = '', this.school = '', this.year = ''});
}

class Experience {
  String jobTitle;
  String company;
  String duration;
  String description;

  Experience({
    this.jobTitle = '',
    this.company = '',
    this.duration = '',
    this.description = '',
  });
}
