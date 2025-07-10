import 'package:freezed_annotation/freezed_annotation.dart';
import '../../models/company.dart';

part 'company_search_state.freezed.dart';

@freezed
class CompanySearchState with _$CompanySearchState {
  const factory CompanySearchState.initial() = Initial;
  const factory CompanySearchState.loading() = Loading;
  const factory CompanySearchState.loaded({
    required List<Company> companies,
    required List<Company> filteredCompanies,
    required String searchQuery,
  }) = Loaded;
  const factory CompanySearchState.error(String message) = Error;
}
