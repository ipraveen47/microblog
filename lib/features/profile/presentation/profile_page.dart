import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:microblog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:microblog/core/theme/app_pallete.dart';
import 'package:microblog/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:microblog/features/blog/presentation/widgets/blog_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../auth/presentation/pages/login_page.dart';

class ProfilePage extends StatelessWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const ProfilePage());
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BlogBloc, BlogState>(
      listener: (context, state) {
        // optional: show snackbars or loaders here
      },
      builder: (context, state) {
        final appUserState = context.read<AppUserCubit>().state;

        if (appUserState is! AppUserLoggedIn) {
          return const Scaffold(
            body: Center(child: Text('User not logged in')),
          );
        }

        final currentUser = appUserState.user;

        if (state is BlogDisplaySuccess) {
          final userBlogs = state.blogs
              .where((blog) => blog.posterId == currentUser.id)
              .toList();

          return Scaffold(
            appBar: AppBar(
              title: const Text('User Profile'),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 70,
                      child: Icon(Icons.person, size: 100),
                    ),
                    const SizedBox(height: 20),
                    Text(currentUser.name),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await Supabase.instance.client.auth.signOut();
                        context
                            .read<AppUserCubit>()
                            .updateUser(null); // Update app state
                        Navigator.pushAndRemoveUntil(
                          context,
                          LoginPage.route(),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPallete.gradient1,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ), // or email, depending on your model
                    const SizedBox(height: 30),
                    const Text('My Blogs', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    if (userBlogs.isEmpty)
                      const Center(child: Text('No blogs found for this user'))
                    else
                      ListView.builder(
                        itemCount: userBlogs.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return BlogCard(
                            blog: userBlogs[index],
                            color: AppPallete.gradient2,
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          );
        }

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
