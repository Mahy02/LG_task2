import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class LgAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LgAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return buildLayout(context);
  }

  Widget buildLayout(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                'Liquid Galaxy Task2',
                style: TextStyle(
                    fontSize: 40,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Image.asset(
            'assets/images/lg.png',
            width: MediaQuery.of(context).size.width * 0.05,
            height: MediaQuery.of(context).size.width * 0.05,
          )
        ],
      ),
      backgroundColor: AppColors.primary,
      actions: const [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
