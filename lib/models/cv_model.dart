class CvModel {
  String fullName;
  String email;
  String phoneNumber;
  String personalStatement;
  List<Education> education;
  List<Experience> experience;
  List<String> skills;

  CvModel({
    this.fullName = '',
    this.email = '',
    this.phoneNumber = '',
    this.personalStatement = '',
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
  String description;

  Experience({
    this.jobTitle = '',
    this.company = '',
    this.description = '',
  });
}
