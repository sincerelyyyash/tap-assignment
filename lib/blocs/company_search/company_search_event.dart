import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_search_event.freezed.dart';

@freezed
class CompanySearchEvent with _$CompanySearchEvent {
  const factory CompanySearchEvent.loadCompanies() = LoadCompanies;
  const factory CompanySearchEvent.searchCompanies(String query) =
      SearchCompanies;
  const factory CompanySearchEvent.clearSearch() = ClearSearch;
}
