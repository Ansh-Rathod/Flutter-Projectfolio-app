import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../models/user_model.dart';
import '../../../repo/upload_project.dart';
import 'package:uuid/uuid.dart';
part 'add_projects_state.dart';

class AddProjectsCubit extends Cubit<AddProjectsState> {
  AddProjectsCubit() : super(AddProjectsState.initial());
  final repo = UploadProjectRepository();
  void addFiles(List<File> files) {
    List<File> fiveImages = [];
    if (files.length > 5) {
      for (int i = 0; i < 5; i++) {
        fiveImages.add(files[i]);
      }
      emit(state.copyWith(files: fiveImages));
    } else {
      emit(state.copyWith(files: files));
    }
  }

  void addtags(String tag) {
    state.tags.add(tag);
    emit(state.copyWith(tags: state.tags, query: ''));
  }

  void removeTags(String tag) {
    state.tags.remove(tag);
    emit(state.copyWith(tags: state.tags));
  }

  void changeText(String text) {
    emit(state.copyWith(query: text));
  }

  void changeType(String type) {
    emit(state.copyWith(type: type));
  }

  void uploadImages(
    UserModel user,
    String title,
    String githubUrl,
    String url,
    String description,
    String type,
  ) async {
    try {
      emit(state.copyWith(status: UploadStatus.uploading));
      List<dynamic> urls = [];
      for (var file in state.files) {
        var url = await repo.uploadImage(file);
        urls.add({
          "url": url['secure_url'],
          "width": url['width'],
          "height": url['height'],
          "format": url['format']
        });
      }
      print(urls);
      emit(state.copyWith(data: urls));
      var status = await submit(
        user,
        title,
        githubUrl,
        url,
        description,
        type,
      );
      if (status == 200) {
        emit(state.copyWith(status: UploadStatus.success));
      } else {
        emit(state.copyWith(status: UploadStatus.failed));
      }
    } catch (e) {
      emit(state.copyWith(status: UploadStatus.failed));
    }

    print("dsssss");
  }

  Future<int> submit(
    UserModel user,
    String title,
    String githubUrl,
    String url,
    String description,
    String type,
  ) async {
    return await repo.uploadProject({
      "project_id": const Uuid().v4(),
      "table_id": user.tableId,
      "title": title,
      "github_url": githubUrl,
      "description": description,
      "type": type,
      "project_url": url,
      "posted_at": DateTime.now().toString(),
      "user_id": user.id,
      "tags": state.tags,
      "images": {"data": state.data},
    });
  }
}
