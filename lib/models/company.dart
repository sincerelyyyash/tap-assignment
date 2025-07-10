import 'package:freezed_annotation/freezed_annotation.dart';

part 'company.freezed.dart';
part 'company.g.dart';

@freezed
class Company with _$Company {
  const factory Company({
    required String logo,
    required String isin,
    required String rating,
    required String companyName,
    required List<String> tags,
  }) = _Company;

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      logo: json['logo'] as String,
      isin: json['isin'] as String,
      rating: json['rating'] as String,
      companyName: json['company_name'] as String,
      tags: List<String>.from(json['tags'] as List),
    );
  }
}

@freezed
class CompanyResponse with _$CompanyResponse {
  const factory CompanyResponse({required List<Company> data}) =
      _CompanyResponse;

  factory CompanyResponse.fromJson(Map<String, dynamic> json) =>
      _$CompanyResponseFromJson(json);
}
