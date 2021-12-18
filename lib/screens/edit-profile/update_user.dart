// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectfolio/models/user_model.dart';
import 'package:projectfolio/screens/edit-profile/cubit/update_user_cubit.dart';

class UpdateUser extends StatefulWidget {
  final UserModel currentUser;
  const UpdateUser({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController website = TextEditingController();
  TextEditingController bio = TextEditingController();
  TextEditingController blog = TextEditingController();
  TextEditingController company = TextEditingController();
  TextEditingController location = TextEditingController();
  @override
  void initState() {
    name.text = widget.currentUser.name ?? '';
    website.text = widget.currentUser.twitterUsername ?? '';
    bio.text = widget.currentUser.bio ?? '';
    blog.text = widget.currentUser.blog ?? '';
    company.text = widget.currentUser.company ?? '';
    location.text = widget.currentUser.location ?? '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateUserCubit(),
      child: Scaffold(
        appBar: CupertinoNavigationBar(
          middle: Text(
            "UPDATE PROFILE",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          border: Border(
              bottom: BorderSide(width: .4, color: Colors.grey.shade600)),
          backgroundColor: Colors.transparent,
        ),
        body: BlocConsumer<UpdateUserCubit, UpdateUserState>(
          listener: (context, state) {
            if (state.status == UserStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 4),
                  dismissDirection: DismissDirection.horizontal,
                  backgroundColor: Colors.redAccent,
                  content: Text(state.error!),
                ),
              );
            }
            if (state.status == UserStatus.success) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      TextFormField(
                        controller: name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        validator: (val) => val!.trim().isEmpty &&
                                val.length > 4
                            ? 'Please fill the field and must be more than 4 characters'
                            : null,
                        decoration: const InputDecoration(
                          hintText: 'Name',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: website,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Twitter username',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: company,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Company',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: location,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Location',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: blog,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'blog',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: bio,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: null,
                        maxLength: 300,
                        decoration: const InputDecoration(
                            hintText: 'Add some thing about You'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ButtonTheme(
                        minWidth: double.infinity,
                        child: RaisedButton(
                          elevation: 0,
                          hoverElevation: 0,
                          disabledColor: Colors.grey,
                          focusElevation: 0,
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          onPressed: state.status != UserStatus.loading
                              ? () {
                                  FocusScope.of(context).unfocus();
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState!.save();
                                    BlocProvider.of<UpdateUserCubit>(context)
                                        .submit(
                                      location: location.text,
                                      company: company.text,
                                      tnme: website.text,
                                      blog: blog.text,
                                      id: widget.currentUser.id!,
                                      name: name.text,
                                      bio: bio.text,
                                    );
                                  }
                                }
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              state.status != UserStatus.loading
                                  ? "UPDATE DETAILS".toUpperCase()
                                  : "updating..".toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
