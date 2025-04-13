import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:microblog/core/common/widgets/loader.dart';
import 'package:microblog/core/theme/app_pallete.dart';
import 'package:microblog/core/utils/show_snackbar.dart';
import 'package:microblog/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:microblog/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:microblog/features/profile/presentation/profile_page.dart';
import 'package:microblog/features/blog/presentation/widgets/blog_card.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const BlogPage());
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(context, ProfilePage.route());
          },
          child: const Padding(
            padding: EdgeInsets.only(
              left: 10,
            ),
            child: CircleAvatar(
              radius: 30,
              child: Icon(
                Icons.person,
                size: 30,
              ),
            ),
          ),
        ),
        title: const Text(
          'miniBlog',
          style: TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 30,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, AddNewBlogPage.route());
            },
            icon: const Icon(
              Icons.add_circle,
              size: 50,
            ),
          )
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackbar(context, state.error);
          } else if (state is BlogDeleteSuccess) {
            showSnackbar(context, "Blog Deleted Successfully ");
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          } else if (state is BlogDisplaySuccess) {
            if (state.blogs.isEmpty) {
              return const Center(child: Text("No Blogs Available"));
            }
            return ListView.builder(
              itemCount: state.blogs.length,
              itemBuilder: (context, index) {
                final blog = state.blogs[index];
                return BlogCard(
                  blog: blog,
                  color: AppPallete.gradient1,
                );
              },
            );
          }
          return const Center(
              child: Text("Something went wrong. Please try again."));
        },
      ),
    );
  }
}
