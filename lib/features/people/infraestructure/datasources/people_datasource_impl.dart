import 'package:cars_app/config/config.dart';
import 'package:cars_app/features/people/domain/domain.dart';
import 'package:cars_app/features/people/infraestructure/infraestructure.dart';
import 'package:dio/dio.dart';

class PeopleDatasourceImpl extends PeopleDatasource {
  late final Dio dio;
  final String accessToken;

  PeopleDatasourceImpl({
    required this.accessToken,
  }) : dio = Dio(
          BaseOptions(
            baseUrl: Environment.apiUrl,
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
        );

  @override
  Future<People> createUpdatePeople(Map<String, dynamic> peopleLike) {
    // TODO: implement createUpdatePeople
    throw UnimplementedError();
  }

  @override
  Future<People> getPeopleByDocument(int doc) {
    // TODO: implement getPeopleByDocument
    throw UnimplementedError();
  }

  @override
  Future<People> getPeopleById(int id) async {
    try {
      final response = await dio.get('/people/$id');
      final person = PeopleMapper.jsonToEntity(response.data);
      return person;
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) throw PersonNotFound();
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<People>> getPeopleByPage({int limit = 10, int offset = 0}) async {
    final response = await dio.get<List>('/people?limit=$limit&offset=$offset');
    final List<People> people = [];

    for (var person in response.data ?? []) {
      people.add(PeopleMapper.jsonToEntity(person));
    }

    return people;
  }
}
