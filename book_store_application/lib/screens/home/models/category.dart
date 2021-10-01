class Category {
  Category({
    this.title = '',
    this.imagePath = '',
    this.count = 0,
    this.money = 0,
  });

  String title;
  int count;
  int money;
  String imagePath;

  static List<Category> categoryList = <Category>[
    Category(
      imagePath: 'assets/images/img_2.png',
      title: 'Name',
      count: 24,
      money: 25,
    ),
    Category(
      imagePath: 'assets/images/img_2.png',
      title: 'Name',
      count: 22,
      money: 18,
    ),
    Category(
      imagePath: 'assets/images/img_2.png',
      title: 'Name',
      count: 24,
      money: 25,
    ),
    Category(
      imagePath: 'assets/images/img_2.png',
      title: 'Name',
      count: 22,
      money: 18,
    ),
  ];

  static List<Category> popularCourseList = <Category>[
    Category(
      imagePath: 'assets/images/img_2.png',
      title: 'Name of Book',
      count: 12,
      money: 25,
    ),
    Category(
      imagePath: 'assets/images/img_2.png',
      title: 'Name of Book',
      count: 28,
      money: 208,
    ),
    Category(
      imagePath: 'assets/images/img_2.png',
      title: 'Name of Book',
      count: 12,
      money: 25,
    ),
    Category(
      imagePath: 'assets/images/img_2.png',
      title: 'Name of Book',
      count: 28,
      money: 208,
    ),
  ];
}