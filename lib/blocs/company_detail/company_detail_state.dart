import 'package:equatable/equatable.dart';
import '../../models/company_detail.dart';

abstract class CompanyDetailState extends Equatable {
  const CompanyDetailState();

  @override
  List<Object?> get props => [];
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

  @override
  List<Object?> get props => [companyDetail];
}

class CompanyDetailError extends CompanyDetailState {
  final String message;

  const CompanyDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
