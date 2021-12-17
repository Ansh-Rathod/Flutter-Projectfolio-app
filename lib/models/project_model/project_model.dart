import 'images.dart';

class ProjectModel {
  String? projectId;
  String? title;
  String? githubUrl;
  String? description;
  String? type;
  String? projectUrl;
  String? postedAt;
  String? userId;
  List<dynamic>? likes;
  List<dynamic>? tags;
  Images? images;
  String? id;
  String? tableId;
  String? username;
  String? name;
  String? bio;
  String? avatarUrl;
  String? htmlUrl;
  String? twitterUsername;
  String? company;
  String? location;
  dynamic email;
  String? blog;
  int? followingCount;
  int? followersCount;
  int? projectsCount;

  ProjectModel({
    this.projectId,
    this.title,
    this.githubUrl,
    this.description,
    this.type,
    this.projectUrl,
    this.postedAt,
    this.userId,
    this.likes,
    this.tags,
    this.images,
    this.id,
    this.tableId,
    this.username,
    this.name,
    this.bio,
    this.avatarUrl,
    this.htmlUrl,
    this.twitterUsername,
    this.company,
    this.location,
    this.email,
    this.blog,
    this.followingCount,
    this.followersCount,
    this.projectsCount,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
        projectId: json['project_id'] as String?,
        title: json['title'] as String?,
        githubUrl: json['github_url'] as String?,
        description: json['description'] as String?,
        type: json['type'] as String?,
        projectUrl: json['project_url'] as String?,
        postedAt: json['posted_at'] as String?,
        userId: json['user_id'] as String?,
        likes: json['likes'] as List<dynamic>?,
        tags: json['tags'] as List<dynamic>?,
        images: json['images'] == null
            ? null
            : Images.fromJson(json['images'] as Map<String, dynamic>),
        id: json['id'] as String?,
        tableId: json['table_id'] as String?,
        username: json['username'] as String?,
        name: json['name'] as String?,
        bio: json['bio'] as String?,
        avatarUrl: json['avatar_url'] as String?,
        htmlUrl: json['html_url'] as String?,
        twitterUsername: json['twitter_username'] as String?,
        company: json['company'] as String?,
        location: json['location'] as String?,
        email: json['email'] as dynamic?,
        blog: json['blog'] as String?,
        followingCount: json['following_count'] as int?,
        followersCount: json['followers_count'] as int?,
        projectsCount: json['projects_count'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'project_id': projectId,
        'title': title,
        'github_url': githubUrl,
        'description': description,
        'type': type,
        'project_url': projectUrl,
        'posted_at': postedAt,
        'user_id': userId,
        'likes': likes,
        'tags': tags,
        'images': images?.toJson(),
        'id': id,
        'table_id': tableId,
        'username': username,
        'name': name,
        'bio': bio,
        'avatar_url': avatarUrl,
        'html_url': htmlUrl,
        'twitter_username': twitterUsername,
        'company': company,
        'location': location,
        'email': email,
        'blog': blog,
        'following_count': followingCount,
        'followers_count': followersCount,
        'projects_count': projectsCount,
      };
  void like(id) {
    likes!.add(id);
  }

  void remove(id) {
    likes!.remove(id);
  }
}
