import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tap_assignment/blocs/company_search/company_search_bloc.dart';
import 'package:tap_assignment/blocs/company_search/company_search_event.dart';
import 'package:tap_assignment/blocs/company_search/company_search_state.dart';
import 'package:tap_assignment/models/company.dart';
import '../helpers/test_helpers.dart';

void main() {
  late CompanySearchBloc companySearchBloc;
  late MockCompanyRepository mockRepository;

  setUp(() {
    mockRepository = MockCompanyRepository();
    companySearchBloc = CompanySearchBloc(mockRepository);
    setupCompanyRepositoryMock(mockRepository);
  });

  tearDown(() {
    companySearchBloc.close();
  });

  group('CompanySearchBloc', () {
    test('initial state should be Initial', () {
      expect(companySearchBloc.state, const CompanySearchState.initial());
    });

    group('LoadCompanies Event', () {
      blocTest<CompanySearchBloc, CompanySearchState>(
        'emits [loading, loaded] when LoadCompanies succeeds',
        build: () => companySearchBloc,
        act: (bloc) => bloc.add(const CompanySearchEvent.loadCompanies()),
        expect: () => [
          const CompanySearchState.loading(),
          CompanySearchState.loaded(
            companies: testCompanies,
            filteredCompanies: testCompanies,
            searchQuery: '',
          ),
        ],
        verify: (_) {
          verify(() => mockRepository.getCompanies()).called(1);
        },
      );

      blocTest<CompanySearchBloc, CompanySearchState>(
        'emits [loading, error] when LoadCompanies fails',
        build: () {
          when(
            () => mockRepository.getCompanies(),
          ).thenThrow(Exception('Network error'));
          return CompanySearchBloc(mockRepository);
        },
        act: (bloc) => bloc.add(const CompanySearchEvent.loadCompanies()),
        expect: () => [
          const CompanySearchState.loading(),
          const CompanySearchState.error(
            'Failed to load companies: Exception: Network error',
          ),
        ],
        verify: (_) {
          verify(() => mockRepository.getCompanies()).called(1);
        },
      );

      blocTest<CompanySearchBloc, CompanySearchState>(
        'emits [loading, loaded] with empty list when repository returns empty',
        build: () {
          when(
            () => mockRepository.getCompanies(),
          ).thenAnswer((_) async => <Company>[]);
          return CompanySearchBloc(mockRepository);
        },
        act: (bloc) => bloc.add(const CompanySearchEvent.loadCompanies()),
        expect: () => [
          const CompanySearchState.loading(),
          CompanySearchState.loaded(
            companies: <Company>[],
            filteredCompanies: <Company>[],
            searchQuery: '',
          ),
        ],
      );
    });

    group('SearchCompanies Event', () {
      blocTest<CompanySearchBloc, CompanySearchState>(
        'should filter companies by ISIN when search query provided',
        build: () => companySearchBloc,
        seed: () => CompanySearchState.loaded(
          companies: testCompanies,
          filteredCompanies: testCompanies,
          searchQuery: '',
        ),
        act: (bloc) =>
            bloc.add(const CompanySearchEvent.searchCompanies('INE001A01036')),
        expect: () => [
          CompanySearchState.loaded(
            companies: testCompanies,
            filteredCompanies: [testCompanies[1]], // Only Reliance Industries
            searchQuery: 'INE001A01036',
          ),
        ],
      );

      blocTest<CompanySearchBloc, CompanySearchState>(
        'should filter companies by company name when search query provided',
        build: () => companySearchBloc,
        seed: () => CompanySearchState.loaded(
          companies: testCompanies,
          filteredCompanies: testCompanies,
          searchQuery: '',
        ),
        act: (bloc) =>
            bloc.add(const CompanySearchEvent.searchCompanies('Tata')),
        expect: () => [
          CompanySearchState.loaded(
            companies: testCompanies,
            filteredCompanies: [testCompanies[2]], // Only TCS
            searchQuery: 'Tata',
          ),
        ],
      );

      blocTest<CompanySearchBloc, CompanySearchState>(
        'should filter companies by tags when search query provided',
        build: () => companySearchBloc,
        seed: () => CompanySearchState.loaded(
          companies: testCompanies,
          filteredCompanies: testCompanies,
          searchQuery: '',
        ),
        act: (bloc) => bloc.add(const CompanySearchEvent.searchCompanies('IT')),
        expect: () => [
          CompanySearchState.loaded(
            companies: testCompanies,
            filteredCompanies: [
              testCompanies[1], // Reliance (substring match in "Limited")
              testCompanies[2], // TCS (IT tag)
              testCompanies[3], // Infosys (IT tag)
            ],
            searchQuery: 'IT',
          ),
        ],
      );

      blocTest<CompanySearchBloc, CompanySearchState>(
        'should return all companies when search query is empty',
        build: () => companySearchBloc,
        seed: () => CompanySearchState.loaded(
          companies: testCompanies,
          filteredCompanies: [testCompanies[0]], // Previously filtered
          searchQuery: 'previousQuery',
        ),
        act: (bloc) => bloc.add(const CompanySearchEvent.searchCompanies('')),
        expect: () => [
          CompanySearchState.loaded(
            companies: testCompanies,
            filteredCompanies: testCompanies, // All companies returned
            searchQuery: '',
          ),
        ],
      );

      blocTest<CompanySearchBloc, CompanySearchState>(
        'should handle case-insensitive search',
        build: () => companySearchBloc,
        seed: () => CompanySearchState.loaded(
          companies: testCompanies,
          filteredCompanies: testCompanies,
          searchQuery: '',
        ),
        act: (bloc) =>
            bloc.add(const CompanySearchEvent.searchCompanies('reliance')),
        expect: () => [
          CompanySearchState.loaded(
            companies: testCompanies,
            filteredCompanies: [
              testCompanies[1],
            ], // Reliance Industries (case-insensitive)
            searchQuery: 'reliance',
          ),
        ],
      );

      blocTest<CompanySearchBloc, CompanySearchState>(
        'should return empty list when no matches found',
        build: () => companySearchBloc,
        seed: () => CompanySearchState.loaded(
          companies: testCompanies,
          filteredCompanies: testCompanies,
          searchQuery: '',
        ),
        act: (bloc) => bloc.add(
          const CompanySearchEvent.searchCompanies('NonExistentCompany'),
        ),
        expect: () => [
          CompanySearchState.loaded(
            companies: testCompanies,
            filteredCompanies: <Company>[], // No matches
            searchQuery: 'NonExistentCompany',
          ),
        ],
      );

      blocTest<CompanySearchBloc, CompanySearchState>(
        'should handle multiple search terms',
        build: () => companySearchBloc,
        seed: () => CompanySearchState.loaded(
          companies: testCompanies,
          filteredCompanies: testCompanies,
          searchQuery: '',
        ),
        act: (bloc) => bloc.add(
          const CompanySearchEvent.searchCompanies('Industries Energy'),
        ),
        expect: () => [
          CompanySearchState.loaded(
            companies: testCompanies,
            filteredCompanies: [
              testCompanies[1],
            ], // Reliance Industries (matches both terms)
            searchQuery: 'Industries Energy',
          ),
        ],
      );

      blocTest<CompanySearchBloc, CompanySearchState>(
        'should ignore extra whitespace in search query',
        build: () => companySearchBloc,
        seed: () => CompanySearchState.loaded(
          companies: testCompanies,
          filteredCompanies: testCompanies,
          searchQuery: '',
        ),
        act: (bloc) =>
            bloc.add(const CompanySearchEvent.searchCompanies('  Reliance  ')),
        expect: () => [
          CompanySearchState.loaded(
            companies: testCompanies,
            filteredCompanies: [testCompanies[1]], // Reliance Industries
            searchQuery: '  Reliance  ',
          ),
        ],
      );

      blocTest<CompanySearchBloc, CompanySearchState>(
        'should not emit new state when bloc is not in loaded state',
        build: () => companySearchBloc,
        seed: () => const CompanySearchState.loading(),
        act: (bloc) =>
            bloc.add(const CompanySearchEvent.searchCompanies('test')),
        expect: () => <CompanySearchState>[],
      );

      blocTest<CompanySearchBloc, CompanySearchState>(
        'should handle special characters in search query',
        build: () => companySearchBloc,
        seed: () => CompanySearchState.loaded(
          companies: testCompanies,
          filteredCompanies: testCompanies,
          searchQuery: '',
        ),
        act: (bloc) =>
            bloc.add(const CompanySearchEvent.searchCompanies('Tata@#\$%')),
        expect: () => [
          CompanySearchState.loaded(
            companies: testCompanies,
            filteredCompanies: <Company>[], // No matches for special characters
            searchQuery: 'Tata@#\$%',
          ),
        ],
      );

      blocTest<CompanySearchBloc, CompanySearchState>(
        'should handle very long search query',
        build: () => companySearchBloc,
        seed: () => CompanySearchState.loaded(
          companies: testCompanies,
          filteredCompanies: testCompanies,
          searchQuery: '',
        ),
        act: (bloc) {
          final longQuery = 'Reliance' * 100; // Very long query
          bloc.add(CompanySearchEvent.searchCompanies(longQuery));
        },
        expect: () => [
          CompanySearchState.loaded(
            companies: testCompanies,
            filteredCompanies:
                <Company>[], // No exact matches for very long query
            searchQuery: 'Reliance' * 100,
          ),
        ],
      );
    });

    group('ClearSearch Event', () {
      blocTest<CompanySearchBloc, CompanySearchState>(
        'should reset filtered companies to all companies when clearing search',
        build: () => companySearchBloc,
        seed: () => CompanySearchState.loaded(
          companies: testCompanies,
          filteredCompanies: [testCompanies[1]], // Previously filtered
          searchQuery: 'previousQuery',
        ),
        act: (bloc) => bloc.add(const CompanySearchEvent.clearSearch()),
        expect: () => [
          CompanySearchState.loaded(
            companies: testCompanies,
            filteredCompanies: testCompanies, // All companies
            searchQuery: '',
          ),
        ],
      );

      blocTest<CompanySearchBloc, CompanySearchState>(
        'should not emit new state when bloc is not in loaded state',
        build: () => companySearchBloc,
        seed: () => const CompanySearchState.loading(),
        act: (bloc) => bloc.add(const CompanySearchEvent.clearSearch()),
        expect: () => <CompanySearchState>[],
      );

      blocTest<CompanySearchBloc, CompanySearchState>(
        'should handle clear search when already showing all companies',
        build: () => companySearchBloc,
        seed: () => CompanySearchState.loaded(
          companies: testCompanies,
          filteredCompanies: testCompanies, // Already showing all
          searchQuery: '',
        ),
        act: (bloc) => bloc.add(const CompanySearchEvent.clearSearch()),
        expect: () => <CompanySearchState>[], // No state change expected since already showing all
      );
    });

    group('Complex Scenarios', () {
      blocTest<CompanySearchBloc, CompanySearchState>(
        'should handle consecutive search operations correctly',
        build: () => companySearchBloc,
        seed: () => CompanySearchState.loaded(
          companies: testCompanies,
          filteredCompanies: testCompanies,
          searchQuery: '',
        ),
        act: (bloc) {
          bloc.add(const CompanySearchEvent.searchCompanies('IT'));
          bloc.add(const CompanySearchEvent.searchCompanies('Tata'));
          bloc.add(const CompanySearchEvent.clearSearch());
        },
        expect: () => [
          CompanySearchState.loaded(
            companies: testCompanies,
            filteredCompanies: [
              testCompanies[1], // Reliance (substring match in "Limited")
              testCompanies[2], // TCS (IT tag)
              testCompanies[3], // Infosys (IT tag)
            ], // IT companies
            searchQuery: 'IT',
          ),
          CompanySearchState.loaded(
            companies: testCompanies,
            filteredCompanies: [testCompanies[2]], // Only TCS
            searchQuery: 'Tata',
          ),
          CompanySearchState.loaded(
            companies: testCompanies,
            filteredCompanies: testCompanies, // All companies after clear
            searchQuery: '',
          ),
        ],
      );

      blocTest<CompanySearchBloc, CompanySearchState>(
        'should maintain original companies list throughout operations',
        build: () => companySearchBloc,
        act: (bloc) {
          bloc.add(const CompanySearchEvent.loadCompanies());
          bloc.add(const CompanySearchEvent.searchCompanies('Reliance'));
          bloc.add(const CompanySearchEvent.searchCompanies('IT'));
          bloc.add(const CompanySearchEvent.clearSearch());
        },
        expect: () => [
          const CompanySearchState.loading(),
          CompanySearchState.loaded(
            companies: testCompanies,
            filteredCompanies: testCompanies,
            searchQuery: '',
          ),
          CompanySearchState.loaded(
            companies: testCompanies, // Original list maintained
            filteredCompanies: [testCompanies[1]],
            searchQuery: 'Reliance',
          ),
          CompanySearchState.loaded(
            companies: testCompanies, // Original list maintained
            filteredCompanies: [
              testCompanies[1], // Reliance (substring match in "Limited")
              testCompanies[2], // TCS (IT tag)
              testCompanies[3], // Infosys (IT tag)
            ],
            searchQuery: 'IT',
          ),
          CompanySearchState.loaded(
            companies: testCompanies, // Original list maintained
            filteredCompanies: testCompanies,
            searchQuery: '',
          ),
        ],
      );
    });
  });
}
