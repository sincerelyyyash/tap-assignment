// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:tap_assignment/blocs/company_search/company_search_bloc.dart'
    as _i231;
import 'package:tap_assignment/repositories/company_repository.dart' as _i791;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i791.CompanyRepository>(() => _i791.CompanyRepositoryImpl());
    gh.factory<_i231.CompanySearchBloc>(
      () => _i231.CompanySearchBloc(gh<_i791.CompanyRepository>()),
    );
    return this;
  }
}
