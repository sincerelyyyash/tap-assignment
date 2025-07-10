import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import '../../models/company_detail.dart';
import 'company_detail_event.dart';
import 'company_detail_state.dart';

@injectable
class CompanyDetailBloc extends Bloc<CompanyDetailEvent, CompanyDetailState> {
  CompanyDetailBloc() : super(const CompanyDetailInitial()) {
    on<LoadCompanyDetail>(_onLoadCompanyDetail);
  }

  Future<void> _onLoadCompanyDetail(
    LoadCompanyDetail event,
    Emitter<CompanyDetailState> emit,
  ) async {
    try {
      emit(const CompanyDetailLoading());

      final response = await http.get(
        Uri.parse('https://eo61q3zd4heiwke.m.pipedream.net/'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final companyDetail = CompanyDetail.fromJson(data);
        emit(CompanyDetailLoaded(companyDetail));
      } else {
        emit(
          CompanyDetailError(
            'Failed to load company details: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      emit(CompanyDetailError('Error loading company details: $e'));
    }
  }
}
