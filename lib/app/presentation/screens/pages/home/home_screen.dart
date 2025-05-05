import 'package:flutter/material.dart';
import 'package:user_panel/core/routes/routes.dart';
import 'package:user_panel/core/utils/constant/constant.dart';

import '../../../../../core/themes/colors.dart';
import '../../../widget/profile_widget/profile_scrollable_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenHeight = constraints.maxHeight;
        double screenWidth = constraints.maxWidth;

        return ColoredBox(
          color: AppPalette.blackClr,
          child: SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              body: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    backgroundColor: AppPalette.blackClr,
                    expandedHeight: screenHeight * 0.13,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  profileviewWidget(
                                    screenWidth,
                                    context,
                                    Icons.location_on,
                                    'Wayanad, sulthan bathery',
                                    AppPalette.redClr,
                                  ),
                                  ConstantWidgets.hight10(context),
                                  Text(
                                    'Hello, Abhiramks',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton.filled(
                                    style: IconButton.styleFrom(
                                      backgroundColor: AppPalette.whiteClr,
                                    ),
                                    icon: Icon(Icons.wallet,
                                        color: AppPalette.blackClr,),
                                    onPressed: () {
                                      Navigator.pushNamed(context, AppRoutes.wallet);
                                    },
                                  ),
                                  IconButton.filled(
                                    style: IconButton.styleFrom(
                                      backgroundColor: AppPalette.whiteClr,
                                    ),
                                    icon: Icon(Icons.favorite,
                                        color: AppPalette.redClr,), // icon color
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// Body Content
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 600,
                      child: Center(
                        child: Text('Body Content',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
