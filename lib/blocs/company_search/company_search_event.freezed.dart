// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'company_search_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CompanySearchEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadCompanies,
    required TResult Function(String query) searchCompanies,
    required TResult Function() clearSearch,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadCompanies,
    TResult? Function(String query)? searchCompanies,
    TResult? Function()? clearSearch,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadCompanies,
    TResult Function(String query)? searchCompanies,
    TResult Function()? clearSearch,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadCompanies value) loadCompanies,
    required TResult Function(SearchCompanies value) searchCompanies,
    required TResult Function(ClearSearch value) clearSearch,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadCompanies value)? loadCompanies,
    TResult? Function(SearchCompanies value)? searchCompanies,
    TResult? Function(ClearSearch value)? clearSearch,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadCompanies value)? loadCompanies,
    TResult Function(SearchCompanies value)? searchCompanies,
    TResult Function(ClearSearch value)? clearSearch,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompanySearchEventCopyWith<$Res> {
  factory $CompanySearchEventCopyWith(
    CompanySearchEvent value,
    $Res Function(CompanySearchEvent) then,
  ) = _$CompanySearchEventCopyWithImpl<$Res, CompanySearchEvent>;
}

/// @nodoc
class _$CompanySearchEventCopyWithImpl<$Res, $Val extends CompanySearchEvent>
    implements $CompanySearchEventCopyWith<$Res> {
  _$CompanySearchEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompanySearchEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LoadCompaniesImplCopyWith<$Res> {
  factory _$$LoadCompaniesImplCopyWith(
    _$LoadCompaniesImpl value,
    $Res Function(_$LoadCompaniesImpl) then,
  ) = __$$LoadCompaniesImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadCompaniesImplCopyWithImpl<$Res>
    extends _$CompanySearchEventCopyWithImpl<$Res, _$LoadCompaniesImpl>
    implements _$$LoadCompaniesImplCopyWith<$Res> {
  __$$LoadCompaniesImplCopyWithImpl(
    _$LoadCompaniesImpl _value,
    $Res Function(_$LoadCompaniesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CompanySearchEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadCompaniesImpl implements LoadCompanies {
  const _$LoadCompaniesImpl();

  @override
  String toString() {
    return 'CompanySearchEvent.loadCompanies()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadCompaniesImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadCompanies,
    required TResult Function(String query) searchCompanies,
    required TResult Function() clearSearch,
  }) {
    return loadCompanies();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadCompanies,
    TResult? Function(String query)? searchCompanies,
    TResult? Function()? clearSearch,
  }) {
    return loadCompanies?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadCompanies,
    TResult Function(String query)? searchCompanies,
    TResult Function()? clearSearch,
    required TResult orElse(),
  }) {
    if (loadCompanies != null) {
      return loadCompanies();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadCompanies value) loadCompanies,
    required TResult Function(SearchCompanies value) searchCompanies,
    required TResult Function(ClearSearch value) clearSearch,
  }) {
    return loadCompanies(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadCompanies value)? loadCompanies,
    TResult? Function(SearchCompanies value)? searchCompanies,
    TResult? Function(ClearSearch value)? clearSearch,
  }) {
    return loadCompanies?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadCompanies value)? loadCompanies,
    TResult Function(SearchCompanies value)? searchCompanies,
    TResult Function(ClearSearch value)? clearSearch,
    required TResult orElse(),
  }) {
    if (loadCompanies != null) {
      return loadCompanies(this);
    }
    return orElse();
  }
}

abstract class LoadCompanies implements CompanySearchEvent {
  const factory LoadCompanies() = _$LoadCompaniesImpl;
}

/// @nodoc
abstract class _$$SearchCompaniesImplCopyWith<$Res> {
  factory _$$SearchCompaniesImplCopyWith(
    _$SearchCompaniesImpl value,
    $Res Function(_$SearchCompaniesImpl) then,
  ) = __$$SearchCompaniesImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String query});
}

/// @nodoc
class __$$SearchCompaniesImplCopyWithImpl<$Res>
    extends _$CompanySearchEventCopyWithImpl<$Res, _$SearchCompaniesImpl>
    implements _$$SearchCompaniesImplCopyWith<$Res> {
  __$$SearchCompaniesImplCopyWithImpl(
    _$SearchCompaniesImpl _value,
    $Res Function(_$SearchCompaniesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CompanySearchEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? query = null}) {
    return _then(
      _$SearchCompaniesImpl(
        null == query
            ? _value.query
            : query // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SearchCompaniesImpl implements SearchCompanies {
  const _$SearchCompaniesImpl(this.query);

  @override
  final String query;

  @override
  String toString() {
    return 'CompanySearchEvent.searchCompanies(query: $query)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchCompaniesImpl &&
            (identical(other.query, query) || other.query == query));
  }

  @override
  int get hashCode => Object.hash(runtimeType, query);

  /// Create a copy of CompanySearchEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchCompaniesImplCopyWith<_$SearchCompaniesImpl> get copyWith =>
      __$$SearchCompaniesImplCopyWithImpl<_$SearchCompaniesImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadCompanies,
    required TResult Function(String query) searchCompanies,
    required TResult Function() clearSearch,
  }) {
    return searchCompanies(query);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadCompanies,
    TResult? Function(String query)? searchCompanies,
    TResult? Function()? clearSearch,
  }) {
    return searchCompanies?.call(query);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadCompanies,
    TResult Function(String query)? searchCompanies,
    TResult Function()? clearSearch,
    required TResult orElse(),
  }) {
    if (searchCompanies != null) {
      return searchCompanies(query);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadCompanies value) loadCompanies,
    required TResult Function(SearchCompanies value) searchCompanies,
    required TResult Function(ClearSearch value) clearSearch,
  }) {
    return searchCompanies(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadCompanies value)? loadCompanies,
    TResult? Function(SearchCompanies value)? searchCompanies,
    TResult? Function(ClearSearch value)? clearSearch,
  }) {
    return searchCompanies?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadCompanies value)? loadCompanies,
    TResult Function(SearchCompanies value)? searchCompanies,
    TResult Function(ClearSearch value)? clearSearch,
    required TResult orElse(),
  }) {
    if (searchCompanies != null) {
      return searchCompanies(this);
    }
    return orElse();
  }
}

abstract class SearchCompanies implements CompanySearchEvent {
  const factory SearchCompanies(final String query) = _$SearchCompaniesImpl;

  String get query;

  /// Create a copy of CompanySearchEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchCompaniesImplCopyWith<_$SearchCompaniesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ClearSearchImplCopyWith<$Res> {
  factory _$$ClearSearchImplCopyWith(
    _$ClearSearchImpl value,
    $Res Function(_$ClearSearchImpl) then,
  ) = __$$ClearSearchImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ClearSearchImplCopyWithImpl<$Res>
    extends _$CompanySearchEventCopyWithImpl<$Res, _$ClearSearchImpl>
    implements _$$ClearSearchImplCopyWith<$Res> {
  __$$ClearSearchImplCopyWithImpl(
    _$ClearSearchImpl _value,
    $Res Function(_$ClearSearchImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CompanySearchEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ClearSearchImpl implements ClearSearch {
  const _$ClearSearchImpl();

  @override
  String toString() {
    return 'CompanySearchEvent.clearSearch()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ClearSearchImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadCompanies,
    required TResult Function(String query) searchCompanies,
    required TResult Function() clearSearch,
  }) {
    return clearSearch();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadCompanies,
    TResult? Function(String query)? searchCompanies,
    TResult? Function()? clearSearch,
  }) {
    return clearSearch?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadCompanies,
    TResult Function(String query)? searchCompanies,
    TResult Function()? clearSearch,
    required TResult orElse(),
  }) {
    if (clearSearch != null) {
      return clearSearch();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadCompanies value) loadCompanies,
    required TResult Function(SearchCompanies value) searchCompanies,
    required TResult Function(ClearSearch value) clearSearch,
  }) {
    return clearSearch(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadCompanies value)? loadCompanies,
    TResult? Function(SearchCompanies value)? searchCompanies,
    TResult? Function(ClearSearch value)? clearSearch,
  }) {
    return clearSearch?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadCompanies value)? loadCompanies,
    TResult Function(SearchCompanies value)? searchCompanies,
    TResult Function(ClearSearch value)? clearSearch,
    required TResult orElse(),
  }) {
    if (clearSearch != null) {
      return clearSearch(this);
    }
    return orElse();
  }
}

abstract class ClearSearch implements CompanySearchEvent {
  const factory ClearSearch() = _$ClearSearchImpl;
}
