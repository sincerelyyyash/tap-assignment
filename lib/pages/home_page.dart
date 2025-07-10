import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import '../blocs/company_search/company_search_bloc.dart';
import '../blocs/company_search/company_search_event.dart';
import '../blocs/company_search/company_search_state.dart';
import '../widgets/company_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    // Load companies when page initializes
    context.read<CompanySearchBloc>().add(
      const CompanySearchEvent.loadCompanies(),
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSearchChanged(String query) {
    // Cancel previous timer
    _debounceTimer?.cancel();

    // If query is empty, update immediately
    if (query.isEmpty) {
      context.read<CompanySearchBloc>().add(
        CompanySearchEvent.searchCompanies(query),
      );
      return;
    }

    // Set a new timer for debouncing non-empty queries
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      context.read<CompanySearchBloc>().add(
        CompanySearchEvent.searchCompanies(query),
      );
    });
  }

  void _handleSearchTap() {
    Haptics.vibrate(HapticsType.selection);
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Search Section
          Container(
            color: Colors.grey.shade50,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                GestureDetector(
                  onTap: _handleSearchTap,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _focusNode.hasFocus
                            ? Colors.blue
                            : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      onChanged: _handleSearchChanged,
                      decoration: const InputDecoration(
                        hintText: 'Search by Issuer Name or ISIN',
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black,
                          size: 20,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Results Section Header
                BlocBuilder<CompanySearchBloc, CompanySearchState>(
                  builder: (context, state) {
                    return state.when(
                      initial: () => const SizedBox.shrink(),
                      loading: () => const SizedBox.shrink(),
                      loaded: (companies, filteredCompanies, searchQuery) {
                        if (searchQuery.isEmpty) {
                          return const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'SUGGESTED RESULTS',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                                letterSpacing: 0.5,
                              ),
                            ),
                          );
                        } else {
                          return const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'SEARCH RESULTS',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                                letterSpacing: 0.5,
                              ),
                            ),
                          );
                        }
                      },
                      error: (message) => const SizedBox.shrink(),
                    );
                  },
                ),
              ],
            ),
          ),

          // Companies List
          Expanded(
            child: BlocBuilder<CompanySearchBloc, CompanySearchState>(
              builder: (context, state) {
                return state.when(
                  initial: () => const Center(
                    child: Text('Welcome! Start by searching for companies.'),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  loaded: (companies, filteredCompanies, searchQuery) {
                    if (filteredCompanies.isEmpty) {
                      return const Center(
                        child: Text(
                          'No companies found',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
                      itemCount:
                          1, // Single item containing the card with all companies
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          elevation: 2,
                          shadowColor: Colors.black.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: Colors.white,
                          child: Column(
                            children: filteredCompanies.asMap().entries.map((
                              entry,
                            ) {
                              final index = entry.key;
                              final company = entry.value;
                              final showDivider =
                                  searchQuery.isNotEmpty &&
                                  index != filteredCompanies.length - 1;

                              return CompanyCard(
                                company: company,
                                searchQuery: searchQuery,
                                showDivider: showDivider,
                                onTap: () {
                                  // Handle company card tap
                                  // You can navigate to company details page here
                                },
                              );
                            }).toList(),
                          ),
                        );
                      },
                    );
                  },
                  error: (message) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: $message',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<CompanySearchBloc>().add(
                              const CompanySearchEvent.loadCompanies(),
                            );
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
