class Fav {
  Fav({
    this.title = '',
    this.imagePath = '',
    this.author = '',
    this.money = 0,

  });

  String title, author;
  int money;
  String imagePath;

  static List<Fav> favBookList = <Fav>[
    Fav(
      imagePath: 'assets/images/img_2.png',
      title: 'Name of Book',
      author: 'Author',
      money: 25,

    ),
    Fav(
      imagePath: 'assets/images/img_2.png',
      title: 'Name of Book',
      author:'Author',
      money: 208,

    ),
    Fav(
      imagePath: 'assets/images/img_2.png',
      title: 'Name of Book',
      author: 'Author',
      money: 25,

    ),
    Fav(
      imagePath: 'assets/images/img_2.png',
      title: 'Name of Book',
      author: 'Author',
      money: 208,
    ),
  ];
}