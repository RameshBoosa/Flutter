import 'package:flutter/material.dart';
import 'package:personal_budget/widgets/text.dart';

class DashboardPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Container(
        // Placeholder message when there are no expences added
        height: constraint.maxHeight,
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/placeholder.png', fit: BoxFit.cover),
            SizedBox(height: 24),
            DefaultTextStyle(
              style: TextStyle(),
              child: MyText(
                text: 'Hello!, No expences added yet',
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      );
    });
  }
}
