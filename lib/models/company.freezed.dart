// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'company.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Company _$CompanyFromJson(Map<String, dynamic> json) {
  return _Company.fromJson(json);
}

/// @nodoc
mixin _$Company {
  String get logo => throw _privateConstructorUsedError;
  String get isin => throw _privateConstructorUsedError;
  String get rating => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_name')
  String get companyName => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;

  /// Serializes this Company to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Company
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompanyCopyWith<Company> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompanyCopyWith<$Res> {
  factory $CompanyCopyWith(Company value, $Res Function(Company) then) =
      _$CompanyCopyWithImpl<$Res, Company>;
  @useResult
  $Res call({
    String logo,
    String isin,
    String rating,
    @JsonKey(name: 'company_name') String companyName,
    List<String> tags,
  });
}

/// @nodoc
class _$CompanyCopyWithImpl<$Res, $Val extends Company>
    implements $CompanyCopyWith<$Res> {
  _$CompanyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Company
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? logo = null,
    Object? isin = null,
    Object? rating = null,
    Object? companyName = null,
    Object? tags = null,
  }) {
    return _then(
      _value.copyWith(
            logo: null == logo
                ? _value.logo
                : logo // ignore: cast_nullable_to_non_nullable
                      as String,
            isin: null == isin
                ? _value.isin
                : isin // ignore: cast_nullable_to_non_nullable
                      as String,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as String,
            companyName: null == companyName
                ? _value.companyName
                : companyName // ignore: cast_nullable_to_non_nullable
                      as String,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CompanyImplCopyWith<$Res> implements $CompanyCopyWith<$Res> {
  factory _$$CompanyImplCopyWith(
    _$CompanyImpl value,
    $Res Function(_$CompanyImpl) then,
  ) = __$$CompanyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String logo,
    String isin,
    String rating,
    @JsonKey(name: 'company_name') String companyName,
    List<String> tags,
  });
}

/// @nodoc
class __$$CompanyImplCopyWithImpl<$Res>
    extends _$CompanyCopyWithImpl<$Res, _$CompanyImpl>
    implements _$$CompanyImplCopyWith<$Res> {
  __$$CompanyImplCopyWithImpl(
    _$CompanyImpl _value,
    $Res Function(_$CompanyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Company
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? logo = null,
    Object? isin = null,
    Object? rating = null,
    Object? companyName = null,
    Object? tags = null,
  }) {
    return _then(
      _$CompanyImpl(
        logo: null == logo
            ? _value.logo
            : logo // ignore: cast_nullable_to_non_nullable
                  as String,
        isin: null == isin
            ? _value.isin
            : isin // ignore: cast_nullable_to_non_nullable
                  as String,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as String,
        companyName: null == companyName
            ? _value.companyName
            : companyName // ignore: cast_nullable_to_non_nullable
                  as String,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CompanyImpl implements _Company {
  const _$CompanyImpl({
    required this.logo,
    required this.isin,
    required this.rating,
    @JsonKey(name: 'company_name') required this.companyName,
    required final List<String> tags,
  }) : _tags = tags;

  factory _$CompanyImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompanyImplFromJson(json);

  @override
  final String logo;
  @override
  final String isin;
  @override
  final String rating;
  @override
  @JsonKey(name: 'company_name')
  final String companyName;
  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  String toString() {
    return 'Company(logo: $logo, isin: $isin, rating: $rating, companyName: $companyName, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompanyImpl &&
            (identical(other.logo, logo) || other.logo == logo) &&
            (identical(other.isin, isin) || other.isin == isin) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    logo,
    isin,
    rating,
    companyName,
    const DeepCollectionEquality().hash(_tags),
  );

  /// Create a copy of Company
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompanyImplCopyWith<_$CompanyImpl> get copyWith =>
      __$$CompanyImplCopyWithImpl<_$CompanyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompanyImplToJson(this);
  }
}

abstract class _Company implements Company {
  const factory _Company({
    required final String logo,
    required final String isin,
    required final String rating,
    @JsonKey(name: 'company_name') required final String companyName,
    required final List<String> tags,
  }) = _$CompanyImpl;

  factory _Company.fromJson(Map<String, dynamic> json) = _$CompanyImpl.fromJson;

  @override
  String get logo;
  @override
  String get isin;
  @override
  String get rating;
  @override
  @JsonKey(name: 'company_name')
  String get companyName;
  @override
  List<String> get tags;

  /// Create a copy of Company
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompanyImplCopyWith<_$CompanyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CompanyResponse _$CompanyResponseFromJson(Map<String, dynamic> json) {
  return _CompanyResponse.fromJson(json);
}

/// @nodoc
mixin _$CompanyResponse {
  List<Company> get data => throw _privateConstructorUsedError;

  /// Serializes this CompanyResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CompanyResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompanyResponseCopyWith<CompanyResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompanyResponseCopyWith<$Res> {
  factory $CompanyResponseCopyWith(
    CompanyResponse value,
    $Res Function(CompanyResponse) then,
  ) = _$CompanyResponseCopyWithImpl<$Res, CompanyResponse>;
  @useResult
  $Res call({List<Company> data});
}

/// @nodoc
class _$CompanyResponseCopyWithImpl<$Res, $Val extends CompanyResponse>
    implements $CompanyResponseCopyWith<$Res> {
  _$CompanyResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompanyResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = null}) {
    return _then(
      _value.copyWith(
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as List<Company>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CompanyResponseImplCopyWith<$Res>
    implements $CompanyResponseCopyWith<$Res> {
  factory _$$CompanyResponseImplCopyWith(
    _$CompanyResponseImpl value,
    $Res Function(_$CompanyResponseImpl) then,
  ) = __$$CompanyResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Company> data});
}

/// @nodoc
class __$$CompanyResponseImplCopyWithImpl<$Res>
    extends _$CompanyResponseCopyWithImpl<$Res, _$CompanyResponseImpl>
    implements _$$CompanyResponseImplCopyWith<$Res> {
  __$$CompanyResponseImplCopyWithImpl(
    _$CompanyResponseImpl _value,
    $Res Function(_$CompanyResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CompanyResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = null}) {
    return _then(
      _$CompanyResponseImpl(
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<Company>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CompanyResponseImpl implements _CompanyResponse {
  const _$CompanyResponseImpl({required final List<Company> data})
    : _data = data;

  factory _$CompanyResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompanyResponseImplFromJson(json);

  final List<Company> _data;
  @override
  List<Company> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString() {
    return 'CompanyResponse(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompanyResponseImpl &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_data));

  /// Create a copy of CompanyResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompanyResponseImplCopyWith<_$CompanyResponseImpl> get copyWith =>
      __$$CompanyResponseImplCopyWithImpl<_$CompanyResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CompanyResponseImplToJson(this);
  }
}

abstract class _CompanyResponse implements CompanyResponse {
  const factory _CompanyResponse({required final List<Company> data}) =
      _$CompanyResponseImpl;

  factory _CompanyResponse.fromJson(Map<String, dynamic> json) =
      _$CompanyResponseImpl.fromJson;

  @override
  List<Company> get data;

  /// Create a copy of CompanyResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompanyResponseImplCopyWith<_$CompanyResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
