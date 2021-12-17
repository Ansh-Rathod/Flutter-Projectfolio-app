class UserModel {
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
  int? projectsCount;
  int? followersCount;
  int? followingCount;

  UserModel({
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
    this.projectsCount,
    this.followersCount,
    this.followingCount,
  });

  @override
  String toString() {
    return 'UserModel(id: $id, tableId: $tableId, username: $username, name: $name, bio: $bio, avatarUrl: $avatarUrl, htmlUrl: $htmlUrl, twitterUsername: $twitterUsername, company: $company, location: $location, email: $email, blog: $blog, projectsCount: $projectsCount)';
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'].toString(),
        tableId: json['table_id'] as String?,
        username: json['username'] as String?,
        name: json['name'] ?? json['username'] as String?,
        bio: json['bio'] as String?,
        avatarUrl: json['avatar_url'] as String?,
        htmlUrl: json['html_url'] as String?,
        twitterUsername: json['twitter_username'] as String?,
        company: json['company'] as String?,
        location: json['location'] as String?,
        email: json['email'] as dynamic?,
        blog: json['blog'] as String?,
        projectsCount: json['projects_count'] as int?,
        followersCount: json['followers_count'] as int?,
        followingCount: json['following_count'] as int?,
      );

  Map<String, dynamic> toJson() => {
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
        'projects_count': projectsCount,
        'following_count': followersCount,
        'followers_count': followingCount,
      };

  follow() {
    if (followersCount != null) {
      followersCount = followersCount! + 1;
    }
  }

  unfollow() {
    if (followersCount != null) {
      followersCount = followersCount! - 1;
    }
  }
}
