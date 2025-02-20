import 'dart:math';

// List of default profile images
final List<String> profileImages = [
  "assets/images/profile1.jpg",
  "assets/images/profile2.jpg",
  "assets/images/profile3.jpg",
  "assets/images/profile4.jpg",
  "assets/images/profile5.jpg",
];

// Function to get a consistent profile image based on the contact’s name or phone number
int getConsistentIndex(String identifier) {
  int hash = identifier.hashCode; // Generate a hash code
  return hash.abs() % profileImages.length; // Ensure within list bounds
}
