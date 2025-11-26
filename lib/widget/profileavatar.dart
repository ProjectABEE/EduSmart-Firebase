import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class ProfileAvatar extends StatelessWidget {
  final double size;

  const ProfileAvatar({super.key, this.size = 50});

  @override
  Widget build(BuildContext context) {
    final student = context.watch<UserProvider>().student;
    final image = student?.profileImage;

    return CircleAvatar(
      radius: size,
      backgroundImage: (image != null && image.isNotEmpty)
          ? NetworkImage(image)
          : const AssetImage("assets/images/abe2.png") as ImageProvider,
    );
  }
}
