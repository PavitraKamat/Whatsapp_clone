import 'package:flutter/material.dart';
import 'package:wtsp_clone/fireBaseHelper/profile_image_helper.dart';

// class UserProfileHelper extends StatelessWidget {
//   final String photoUrl;
//   final String phone;
//   final double radius;

//   const UserProfileHelper({
//     super.key,
//     required this.photoUrl,
//     required this.phone,
//     this.radius = 25,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final double imageSize = radius * 2;

//     return CircleAvatar(
//       radius: radius,
//       backgroundColor: Colors.grey[200],
//       child: ClipOval(
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             Container(
//               width: imageSize,
//               height: imageSize,
//               color: Colors.grey[300],
//               child: Icon(
//                 Icons.person,
//                 size: radius,
//                 color: Colors.white,
//               ),
//             ),
//             if(photoUrl.isNotEmpty)
//             Image.network(
//               photoUrl,
//               width: imageSize,
//               height: imageSize,
//               fit: BoxFit.cover,
//               loadingBuilder: (context, child, loadingProgress) {
//                 if (loadingProgress == null) return child;
//                 return Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     child, // show the partially loaded image
//                     SizedBox(
//                       width: radius,
//                       height: radius,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         valueColor:
//                             AlwaysStoppedAnimation<Color>(Colors.teal),
//                         value: loadingProgress.expectedTotalBytes != null
//                             ? loadingProgress.cumulativeBytesLoaded /
//                                 loadingProgress.expectedTotalBytes!
//                             : null,
//                       ),
//                     ),
//                   ],
//                 );
//               },
//               errorBuilder: (context, error, stackTrace) {
//                 return Image.asset(
//                   ProfileImageHelper.getProfileImage(phone),
//                   width: imageSize,
//                   height: imageSize,
//                   fit: BoxFit.cover,
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


class UserProfileHelper extends StatelessWidget {
  final String photoUrl;
  final String phone;
  final double radius;

  const UserProfileHelper({
    super.key,
    required this.photoUrl,
    required this.phone,
    this.radius = 25,
  });

  @override
  Widget build(BuildContext context) {
    final double imageSize = radius * 2;

    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[200],
      child: ClipOval(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: imageSize,
              height: imageSize,
              color: Colors.grey[300],
              child: Icon(
                Icons.person,
                size: radius,
                color: Colors.white,
              ),
            ),
            if (photoUrl.isNotEmpty)
              Image.network(
                photoUrl,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return SizedBox(
                      width: radius,
                      height: radius,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.teal),
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  }
                },
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    ProfileImageHelper.getProfileImage(phone),
                    width: imageSize,
                    height: imageSize,
                    fit: BoxFit.cover,
                  );
                },
              )
            else
              Image.asset(
                ProfileImageHelper.getProfileImage(phone),
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
              ),
          ],
        ),
      ),
    );
  }
}
