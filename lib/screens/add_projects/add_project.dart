import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user_model.dart';
import 'cubit/add_projects_cubit.dart';
import '../../widgets/show_snackbar.dart';

class AddProfjects extends StatelessWidget {
  final UserModel currentUser;
  const AddProfjects({
    Key? key,
    required this.currentUser,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<String> list = [
      'Web Apps',
      'React',
      'Open source',
      'NextJS',
      'Flutter',
      'Android',
      'VueJs',
      'Social Media',
      'Chat',
      'E-commerce',
      'Mobile Apps',
      'Angular',
      'Chrome Extension',
      'Ionic',
      'NodeJs',
      'Blockchain',
      'IOS',
      'React Native',
      'Electron',
      'Unity',
      'Unity3D',
      'Unity 2D',
      'Python',
      'Java',
      'JavaScript',
      'Django',
      'Flask',
      'Php',
      'html',
      'css',
      'Sass',
      'Bootstrap',
      'Wordpress',
      'Laravel',
      'Drupal',
      'Magento',
      'Shopify',
      'SEO',
      'SMM',
      'SMM (Social Media Marketing)',
      'Github'
    ];
    List types = [
      'Project',
      'Blog',
      'Website',
      'Android App',
      'iOS App',
      'Native App',
      'Hybrid App'
    ];
    TextEditingController tc = TextEditingController();
    TextEditingController description = TextEditingController();
    TextEditingController title = TextEditingController();
    TextEditingController githubUrl = TextEditingController();
    final formkey = GlobalKey<FormState>();
    TextEditingController url = TextEditingController();
    return BlocProvider(
      create: (context) => AddProjectsCubit(),
      child: BlocConsumer<AddProjectsCubit, AddProjectsState>(
        listener: (context, state) {
          if (state.status == UploadStatus.success) {
            Navigator.pop(context);
            showSnackBarToPage(
                context, 'Project added successfully', Colors.green);
          }
          if (state.status == UploadStatus.failed) {
            Navigator.pop(context);
            showSnackBarToPage(context, 'Something went wrong', Colors.red);
          }
        },
        builder: (context, state) {
          if (state.status == UploadStatus.uploading) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }

          return Scaffold(
            appBar: CupertinoNavigationBar(
              border: const Border(
                bottom: BorderSide(
                  color: Colors.white10,
                ),
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              middle: Text(
                'Add Project',
                style: Theme.of(context).textTheme.headline1!.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                    ),
              ),
            ),
            body: Form(
              key: formkey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    if (state.tags.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: state.tags.map(
                            (s) {
                              return Chip(
                                backgroundColor: Colors.blue[100],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                label: Text(s,
                                    style: TextStyle(color: Colors.blue[900])),
                                onDeleted: () {
                                  BlocProvider.of<AddProjectsCubit>(context)
                                      .removeTags(s);
                                },
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: tc,
                        onChanged: (s) {
                          BlocProvider.of<AddProjectsCubit>(context)
                              .changeText(s);
                        },
                        decoration:
                            const InputDecoration(hintText: 'Add Tags..'),
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                      ),
                    ),
                    if (state.query.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: list.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (c, i) {
                          return list[i]
                                  .toLowerCase()
                                  .contains(state.query.toLowerCase())
                              ? ListTile(
                                  title: Text(list[i],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1),
                                  onTap: () {
                                    if (!state.tags.contains(list[i])) {
                                      tc.clear();
                                      BlocProvider.of<AddProjectsCubit>(context)
                                          .addtags(list[i]);
                                    }
                                  })
                              : Container();
                        },
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                        controller: title,
                        decoration: InputDecoration(
                          hintText: 'Project Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please add some description.';
                          }
                          return null;
                        },
                        controller: description,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                        maxLines: 6,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 12),
                          hintText: 'Description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                        controller: githubUrl,
                        decoration: InputDecoration(
                          hintText: 'Github Url',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                        controller: url,
                        decoration: InputDecoration(
                          hintText: 'Url',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormField<String>(
                        builder: (FormFieldState<String> stat) {
                          return InputDecorator(
                            decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(12, 10, 20, 20),
                              errorStyle: TextStyle(
                                  color: Colors.redAccent, fontSize: 16.0),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                style: Theme.of(context).textTheme.bodyText1,
                                hint: Text(
                                  "Select type",
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                items: types
                                    .map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                    ),
                                  );
                                }).toList(),
                                isExpanded: true,
                                isDense: true,
                                value: state.type,
                                onChanged: (newSelectedBank) {
                                  BlocProvider.of<AddProjectsCubit>(context)
                                      .changeType(newSelectedBank!);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 12.0),
                      child: Text(
                        "Add Images",
                        style: Theme.of(context).textTheme.headline2!.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: .4,
                                ),
                                color: Colors.white.withOpacity(.1),
                              ),
                              child: InkWell(
                                onTap: () async {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles(
                                    allowMultiple: true,
                                    type: FileType.custom,
                                    dialogTitle: 'Select only 5 Images',
                                    allowedExtensions: [
                                      'jpg',
                                      'png',
                                      'jpeg',
                                      'gif'
                                    ],
                                  );

                                  if (result != null) {
                                    List<File> files = result.paths
                                        .map((path) => File(path!))
                                        .toList();
                                    BlocProvider.of<AddProjectsCubit>(context)
                                        .addFiles(files);
                                  } else {
                                    // User canceled the picker
                                  }
                                },
                                child: Center(
                                    child: Icon(
                                  CupertinoIcons.add,
                                  color: Theme.of(context).primaryColor,
                                )),
                              ),
                            ),
                          ),
                          ...state.files
                              .map((e) => Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: .4,
                                          ),
                                          color: Colors.white.withOpacity(.1),
                                        ),
                                        child: Image.file(
                                          e,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CupertinoButton(
                        color: Theme.of(context).primaryColor,
                        child: const Text("Submit"),
                        onPressed: () {
                          final isValid = formkey.currentState!.validate();
                          if (isValid) {
                            formkey.currentState!.save();
                            if (state.files.isNotEmpty) {
                              BlocProvider.of<AddProjectsCubit>(context)
                                  .uploadImages(
                                currentUser,
                                title.text,
                                githubUrl.text,
                                url.text,
                                description.text,
                                state.type,
                              );
                            } else {
                              showSnackBarToPage(
                                  context,
                                  'Please select atleast a one image',
                                  Colors.redAccent);
                            }
                            print('done');
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
