import 'package:flutter/material.dart';

class MenuItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? route;
  final VoidCallback? onReturn;

  const MenuItemWidget({
    super.key,
    required this.icon,
    required this.title,
    this.route,
    this.onReturn,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      child: InkWell(
        onTap: () async {
          if (route != null) {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => route!),
            );
            if (onReturn != null) onReturn!(); // refresh setelah balik
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Data belum siap")));
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            Icon(icon, color: Colors.black87),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
