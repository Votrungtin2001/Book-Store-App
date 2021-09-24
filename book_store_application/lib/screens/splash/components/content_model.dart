class UnbordingContent {
  String image;
  String title;
  String discription;

  UnbordingContent({required this.image, required this.title, required this.discription});
}

List<UnbordingContent> contents = [
  UnbordingContent(
      title: 'Select a Book',
      image: 'assets/images/image_1.svg',
      discription: "More choices. Really fast and convenient with just a few touches."
  ),
  UnbordingContent(
      title: 'Purchase',
      image: 'assets/images/image_2.svg',
      discription: "Easily order books and even can cancel if you change your mind."
  ),
  UnbordingContent(
      title: 'Get Delivered',
      image: 'assets/images/image_3.svg',
      discription: "For your health protection in the Covid-19 pandemic, please let my delivery services send books to you."
  ),
];