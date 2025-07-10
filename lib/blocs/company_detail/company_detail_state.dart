import '../../models/company_detail.dart';

abstract class CompanyDetailState {
  const CompanyDetailState();
}

class CompanyDetailInitial extends CompanyDetailState {
  const CompanyDetailInitial();
}

class CompanyDetailLoading extends CompanyDetailState {
  const CompanyDetailLoading();
}

class CompanyDetailLoaded extends CompanyDetailState {
  final CompanyDetail companyDetail;

  const CompanyDetailLoaded(this.companyDetail);
}

class CompanyDetailError extends CompanyDetailState {
  final String message;

  const CompanyDetailError(this.message);
}
