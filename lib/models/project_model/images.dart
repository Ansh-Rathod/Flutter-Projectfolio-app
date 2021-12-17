import 'datum.dart';

class Images {
	List<Datum>? data;

	Images({this.data});

	factory Images.fromJson(Map<String, dynamic> json) => Images(
				data: (json['data'] as List<dynamic>?)
						?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
						.toList(),
			);

	Map<String, dynamic> toJson() => {
				'data': data?.map((e) => e.toJson()).toList(),
			};
}
