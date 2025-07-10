// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompanyImpl _$$CompanyImplFromJson(Map<String, dynamic> json) =>
    _$CompanyImpl(
      logo: json['logo'] as String,
      isin: json['isin'] as String,
      rating: json['rating'] as String,
      companyName: json['company_name'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$CompanyImplToJson(_$CompanyImpl instance) =>
    <String, dynamic>{
      'logo': instance.logo,
      'isin': instance.isin,
      'rating': instance.rating,
      'company_name': instance.companyName,
      'tags': instance.tags,
    };

_$CompanyResponseImpl _$$CompanyResponseImplFromJson(
  Map<String, dynamic> json,
) => _$CompanyResponseImpl(
  data: (json['data'] as List<dynamic>)
      .map((e) => Company.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$CompanyResponseImplToJson(
  _$CompanyResponseImpl instance,
) => <String, dynamic>{'data': instance.data};
