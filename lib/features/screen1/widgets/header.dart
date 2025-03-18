import 'package:flutter/material.dart';
import 'package:kturag/features/screen2/screen2.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor, // Use theme's background color
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'KTURAG',
            style: Theme.of(context).appBarTheme.titleTextStyle, // Use theme's title style
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Theme.of(context).iconTheme.color), // Use theme's icon color
            onPressed: () {
              // Navigate to Screen2 when settings icon is clicked
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Screen2()),
              );
            },
          ),
        ],
      ),
    );
  }
}
