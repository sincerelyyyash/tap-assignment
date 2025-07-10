import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/company_detail/company_detail_bloc.dart';
import '../blocs/company_detail/company_detail_event.dart';
import '../blocs/company_detail/company_detail_state.dart';
import '../models/company_detail.dart';
import '../widgets/financial_chart.dart';

class CompanyDetailPage extends StatefulWidget {
  const CompanyDetailPage({super.key});

  @override
  State<CompanyDetailPage> createState() => _CompanyDetailPageState();
}

class _CompanyDetailPageState extends State<CompanyDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<CompanyDetailBloc>().add(const LoadCompanyDetail());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('', style: TextStyle(color: Colors.black)),
      ),
      body: BlocBuilder<CompanyDetailBloc, CompanyDetailState>(
        builder: (context, state) {
          if (state is CompanyDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CompanyDetailError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CompanyDetailBloc>().add(
                        const LoadCompanyDetail(),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is CompanyDetailLoaded) {
            return _buildContent(state.companyDetail);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(CompanyDetail companyDetail) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company header section
          Container(
            decoration: BoxDecoration(color: Colors.grey.shade50),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo and company info
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.orange.shade100,
                      ),
                      child: companyDetail.logo.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                companyDetail.logo,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildLogoFallback();
                                },
                              ),
                            )
                          : _buildLogoFallback(),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Company name
                Text(
                  companyDetail.companyName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 8),

                // Description
                Text(
                  companyDetail.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 16),

                // ISIN and Status badges
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Text(
                        'ISIN: ${companyDetail.isin}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Text(
                        companyDetail.status,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Tab bar
                TabBar(
                  controller: _tabController,
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  labelColor: Colors.blue.shade600,
                  unselectedLabelColor: Colors.grey.shade600,
                  indicatorColor: Colors.blue.shade600,
                  indicatorWeight: 2,
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: const [
                    Tab(text: 'ISIN Analysis'),
                    Tab(text: 'Pros & Cons'),
                  ],
                ),
              ],
            ),
          ),

          // Tab content
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: TabBarView(
              controller: _tabController,
              children: [
                // ISIN Analysis Tab
                _buildIsinAnalysisTab(companyDetail),
                // Pros & Cons Tab
                _buildProsAndConsTab(companyDetail),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoFallback() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.orange.shade200,
      ),
      child: Center(
        child: Text(
          'INFRA\nMARKET',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.bold,
            color: Colors.orange.shade800,
            height: 1.1,
          ),
        ),
      ),
    );
  }

  Widget _buildIsinAnalysisTab(CompanyDetail companyDetail) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        children: [
          // Financial Chart
          FinancialChart(financials: companyDetail.financials),

          const SizedBox(height: 16),

          // Issuer Details Card
          _buildIssuerDetailsCard(companyDetail.issuerDetails),

          const SizedBox(height: 200),
        ],
      ),
    );
  }

  Widget _buildProsAndConsTab(CompanyDetail companyDetail) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 2,
              shadowColor: Colors.black.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pros and Cons',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Pros Section
                    const Text(
                      'Pros',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),

                    const SizedBox(height: 12),

                    ...companyDetail.prosAndCons.pros.map(
                      (pro) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 24, // Adjust size as needed
                              height: 24, // Adjust size as needed
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check,
                                color: Colors.green.shade600,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                pro,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Cons Section
                    Text(
                      'Cons',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade700,
                      ),
                    ),

                    const SizedBox(height: 12),

                    ...companyDetail.prosAndCons.cons.map(
                      (con) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.orange.shade600,
                              size: 16,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                con,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 150),
        ],
      ),
    );
  }

  Widget _buildIssuerDetailsCard(IssuerDetails issuerDetails) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 20,
                  color: Colors.blue.shade600,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Issuer Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Divider(height: 1, color: Colors.grey.shade200),
            const SizedBox(height: 8),

            _buildDetailRow('Issuer Name', issuerDetails.issuerName),
            _buildDetailRow('Type of Issuer', issuerDetails.typeOfIssuer),
            _buildDetailRow('Sector', issuerDetails.sector),
            _buildDetailRow('Industry', issuerDetails.industry),
            _buildDetailRow('Issuer nature', issuerDetails.issuerNature),
            _buildDetailRow(
              'Corporate Identity Number (CIN)',
              issuerDetails.cin,
            ),
            _buildDetailRow(
              'Name of the Lead Manager',
              issuerDetails.leadManager,
            ),
            _buildDetailRow('Registrar', issuerDetails.registrar),
            _buildDetailRow(
              'Name of Debenture Trustee',
              issuerDetails.debentureTrustee,
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isLast = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.blue.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.isEmpty ? '-' : value,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (!isLast) const SizedBox(height: 16),
      ],
    );
  }
}
