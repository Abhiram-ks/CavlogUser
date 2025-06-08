
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_panel/app/presentation/screens/settings/settings_subscreens/help_screen.dart';
import 'package:user_panel/app/presentation/widget/profile_widget/profile_scrollview_widget.dart';
import 'package:user_panel/auth/data/models/user_model.dart';
import 'package:user_panel/core/themes/colors.dart';
import 'package:user_panel/core/utils/image/app_images.dart';

import '../../../provider/bloc/fetching_bloc/fetch_user_bloc/fetch_user_bloc.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return LayoutBuilder(builder: (context, constraints) {
      double screenHeight = constraints.maxHeight;
      double screenWidth = constraints.maxWidth;

      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: ColoredBox(
          color:AppPalette.blackClr,
          child: SafeArea(
              child: Scaffold(
                  resizeToAvoidBottomInset: true,
                  body: BlocBuilder<FetchUserBloc, FetchUserState>(
                    buildWhen: (previous, current) => current is FetchUserLoaded,
                    builder: (context, state) {
                      if (state is FetchUserLoading) {
                        return profilepageloading(screenHeight, screenWidth);
                      }
                      else if (state is FetchUserLoaded){
                        return ProfileScrollviewWidget(screenHeight: screenHeight, screenWidth: screenWidth, user: state.user);
                      }
                                     return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.cloud_off_outlined,color: AppPalette.blackClr,size:  50,),
              Text("Oop's Unable to complete the request."),
              Text('Please try again later.'),
              IconButton(onPressed: (){
                context.read<FetchUserBloc>().add(FetchCurrentUserRequst());
              }, 
              icon: Icon(Icons.refresh_rounded))
            ],
          ),
        );
                    },
                  ),
                  
                  floatingActionButton: FloatingActionButton(
                onPressed: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>  HelpScreen(),
                      
                    ),
                  );
                },
                backgroundColor: AppPalette.orengeClr,
                child: const Icon(
                  Icons.smart_toy,
                  color: AppPalette.whiteClr,
                ),
              ),
                  )
                  ),
        ),
      );
    });
  }

  Shimmer profilepageloading(double screenHeight, double screenWidth) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300] ?? AppPalette.greyClr,
      highlightColor: AppPalette.whiteClr,
      child: ProfileScrollviewWidget( screenHeight: screenHeight, screenWidth: screenWidth, user: UserModel(uid: '', userName: 'loading....', phoneNumber: '12456789', address: '', email: 'cavlogenoia@gmail.com', image: AppImages.barberEmpty, age: 20, createdAt: DateTime.now(), google: true)),
     );
  }
}
