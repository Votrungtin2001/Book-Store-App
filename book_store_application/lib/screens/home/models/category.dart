class Category {
  Category({
    this.title = '',
    this.imagePath = '',
    this.count = 0,
    this.money = 0,
    this.rating = 0.0,
  });

  String title;
  int count;
  int money;
  double rating;
  String imagePath;

  static List<Category> categoryList = <Category>[
    Category(
      imagePath: 'assets/design_course/interFace1.png',
      title: 'User interface Design',
      count: 24,
      money: 25,
      rating: 4.3,
    ),
    Category(
      imagePath: 'assets/design_course/interFace2.png',
      title: 'User interface Design',
      count: 22,
      money: 18,
      rating: 4.6,
    ),
    Category(
      imagePath: 'assets/design_course/interFace1.png',
      title: 'User interface Design',
      count: 24,
      money: 25,
      rating: 4.3,
    ),
    Category(
      imagePath: 'assets/design_course/interFace2.png',
      title: 'User interface Design',
      count: 22,
      money: 18,
      rating: 4.6,
    ),
  ];

  static List<Category> popularCourseList = <Category>[
    Category(
      imagePath: 'assets/images/img_2.png',
      title: 'Name of Book',
      count: 12,
      money: 25,
      rating: 4.8,
    ),
    Category(
      imagePath: 'assets/images/img_2.png',
      title: 'Name of Book',
      count: 28,
      money: 208,
      rating: 4.9,
    ),
    Category(
      imagePath: 'assets/images/img_2.png',
      title: 'Name of Book',
      count: 12,
      money: 25,
      rating: 4.8,
    ),
    Category(
      imagePath: 'assets/images/img_2.png',
      title: 'Name of Book',
      count: 28,
      money: 208,
      rating: 4.9,
    ),
  ];
}