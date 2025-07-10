import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import '../models/company.dart';

abstract class CompanyRepository {
  Future<List<Company>> getCompanies();
}

@Injectable(as: CompanyRepository)
class CompanyRepositoryImpl implements CompanyRepository {
  final String _baseUrl = 'https://eol122duf9sy4de.m.pipedream.net/';

  @override
  Future<List<Company>> getCompanies() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final companyResponse = CompanyResponse.fromJson(jsonData);
        return companyResponse.data;
      } else {
        throw Exception('Failed to load companies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load companies: $e');
    }
  }
}
