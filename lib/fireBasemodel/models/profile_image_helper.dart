class ProfileImageHelper {
  static final List<String> profileImages = [
    "assets/images/profile.jpg",
    "assets/images/doggy.jpg",
    "assets/images/ghibli.jpeg",
    "assets/images/puppy.jpg",
    "assets/images/contact1.jpg",
  ];

  /// Returns a profile image based on the identifier (e.g., phone number)
  static String getProfileImage(String identifier) {
    int index = identifier.hashCode % profileImages.length;
    return profileImages[index];
  }
}
