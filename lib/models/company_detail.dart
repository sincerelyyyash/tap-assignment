import 'package:equatable/equatable.dart';

class CompanyDetail extends Equatable {
  final String logo;
  final String companyName;
  final String description;
  final String isin;
  final String status;
  final ProsAndCons prosAndCons;
  final Financials financials;
  final IssuerDetails issuerDetails;

  const CompanyDetail({
    required this.logo,
    required this.companyName,
    required this.description,
    required this.isin,
    required this.status,
    required this.prosAndCons,
    required this.financials,
    required this.issuerDetails,
  });

  @override
  List<Object?> get props => [
    logo,
    companyName,
    description,
    isin,
    status,
    prosAndCons,
    financials,
    issuerDetails,
  ];

  factory CompanyDetail.fromJson(Map<String, dynamic> json) {
    return CompanyDetail(
      logo: json['logo'] ?? '',
      companyName: json['company_name'] ?? '',
      description: json['description'] ?? '',
      isin: json['isin'] ?? '',
      status: json['status'] ?? '',
      prosAndCons: ProsAndCons.fromJson(json['pros_and_cons'] ?? {}),
      financials: Financials.fromJson(json['financials'] ?? {}),
      issuerDetails: IssuerDetails.fromJson(json['issuer_details'] ?? {}),
    );
  }
}

class ProsAndCons extends Equatable {
  final List<String> pros;
  final List<String> cons;

  const ProsAndCons({required this.pros, required this.cons});

  @override
  List<Object?> get props => [pros, cons];

  factory ProsAndCons.fromJson(Map<String, dynamic> json) {
    return ProsAndCons(
      pros: List<String>.from(json['pros'] ?? []),
      cons: List<String>.from(json['cons'] ?? []),
    );
  }
}

class Financials extends Equatable {
  final List<FinancialData> ebitda;
  final List<FinancialData> revenue;

  const Financials({required this.ebitda, required this.revenue});

  @override
  List<Object?> get props => [ebitda, revenue];

  factory Financials.fromJson(Map<String, dynamic> json) {
    return Financials(
      ebitda:
          (json['ebitda'] as List<dynamic>?)
              ?.map((e) => FinancialData.fromJson(e))
              .toList() ??
          [],
      revenue:
          (json['revenue'] as List<dynamic>?)
              ?.map((e) => FinancialData.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class FinancialData extends Equatable {
  final String month;
  final int value;

  const FinancialData({required this.month, required this.value});

  @override
  List<Object?> get props => [month, value];

  factory FinancialData.fromJson(Map<String, dynamic> json) {
    return FinancialData(month: json['month'] ?? '', value: json['value'] ?? 0);
  }
}

class IssuerDetails extends Equatable {
  final String issuerName;
  final String typeOfIssuer;
  final String sector;
  final String industry;
  final String issuerNature;
  final String cin;
  final String leadManager;
  final String registrar;
  final String debentureTrustee;

  const IssuerDetails({
    required this.issuerName,
    required this.typeOfIssuer,
    required this.sector,
    required this.industry,
    required this.issuerNature,
    required this.cin,
    required this.leadManager,
    required this.registrar,
    required this.debentureTrustee,
  });

  @override
  List<Object?> get props => [
    issuerName,
    typeOfIssuer,
    sector,
    industry,
    issuerNature,
    cin,
    leadManager,
    registrar,
    debentureTrustee,
  ];

  factory IssuerDetails.fromJson(Map<String, dynamic> json) {
    return IssuerDetails(
      issuerName: json['issuer_name'] ?? '',
      typeOfIssuer: json['type_of_issuer'] ?? '',
      sector: json['sector'] ?? '',
      industry: json['industry'] ?? '',
      issuerNature: json['issuer_nature'] ?? '',
      cin: json['cin'] ?? '',
      leadManager: json['lead_manager'] ?? '',
      registrar: json['registrar'] ?? '',
      debentureTrustee: json['debenture_trustee'] ?? '',
    );
  }
}
