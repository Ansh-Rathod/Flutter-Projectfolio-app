class Datum {
	String? url;
	int? width;
	String? format;
	int? height;

	Datum({this.url, this.width, this.format, this.height});

	factory Datum.fromJson(Map<String, dynamic> json) => Datum(
				url: json['url'] as String?,
				width: json['width'] as int?,
				format: json['format'] as String?,
				height: json['height'] as int?,
			);

	Map<String, dynamic> toJson() => {
				'url': url,
				'width': width,
				'format': format,
				'height': height,
			};
}
