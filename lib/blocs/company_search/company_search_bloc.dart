import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../models/company.dart';
import '../../repositories/company_repository.dart';
import 'company_search_event.dart';
import 'company_search_state.dart';

@injectable
class CompanySearchBloc extends Bloc<CompanySearchEvent, CompanySearchState> {
  final CompanyRepository _companyRepository;

  CompanySearchBloc(this._companyRepository)
    : super(const CompanySearchState.initial()) {
    on<LoadCompanies>(_onLoadCompanies);
    on<SearchCompanies>(_onSearchCompanies);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onLoadCompanies(
    LoadCompanies event,
    Emitter<CompanySearchState> emit,
  ) async {
    emit(const CompanySearchState.loading());

    try {
      final companies = await _companyRepository.getCompanies();
      emit(
        CompanySearchState.loaded(
          companies: companies,
          filteredCompanies: companies,
          searchQuery: '',
        ),
      );
    } catch (e) {
      emit(
        CompanySearchState.error('Failed to load companies: ${e.toString()}'),
      );
    }
  }

  void _onSearchCompanies(
    SearchCompanies event,
    Emitter<CompanySearchState> emit,
  ) {
    state.whenOrNull(
      loaded: (companies, _, __) {
        final filteredCompanies = _filterCompanies(companies, event.query);
        emit(
          CompanySearchState.loaded(
            companies: companies,
            filteredCompanies: filteredCompanies,
            searchQuery: event.query,
          ),
        );
      },
    );
  }

  void _onClearSearch(ClearSearch event, Emitter<CompanySearchState> emit) {
    state.whenOrNull(
      loaded: (companies, _, __) {
        emit(
          CompanySearchState.loaded(
            companies: companies,
            filteredCompanies: companies,
            searchQuery: '',
          ),
        );
      },
    );
  }

  List<Company> _filterCompanies(List<Company> companies, String query) {
    if (query.isEmpty) return companies;

    // Split query into individual terms and filter out empty strings
    final searchTerms = query
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((term) => term.isNotEmpty)
        .toList();

    if (searchTerms.isEmpty) return companies;

    return companies.where((company) {
      // Check if any search term matches any field of the company
      return searchTerms.any(
        (term) =>
            company.companyName.toLowerCase().contains(term) ||
            company.isin.toLowerCase().contains(term) ||
            company.tags.any((tag) => tag.toLowerCase().contains(term)),
      );
    }).toList();
  }
}
