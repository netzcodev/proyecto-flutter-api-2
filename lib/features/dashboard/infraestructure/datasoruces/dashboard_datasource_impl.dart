import 'package:cars_app/config/config.dart';
import 'package:cars_app/features/dashboard/domain/domain.dart';
import 'package:cars_app/features/schedules/domain/entities/schedule_entity.dart';
import 'package:cars_app/features/schedules/schedules.dart';
import 'package:cars_app/features/services/domain/entities/service_entity.dart';
import 'package:cars_app/features/services/infraestructure/infraestructure.dart';
import 'package:dio/dio.dart';

class DashboardDatasourceImpl implements DashboardDatasource {
  final String accessToken;
  late final Dio dio;

  DashboardDatasourceImpl({
    required this.accessToken,
  }) : dio = Dio(
          BaseOptions(
            baseUrl: Environment.apiUrl,
            headers: {
              'Authorization': 'Bearer $accessToken',
            },
          ),
        );

  @override
  Future<Schedule?> getComingSchedule(int userId) async {
    try {
      final response = await dio.get('/schedules/coming?id=$userId');
      if (response.data.runtimeType != Null) {
        final service = SchedulesMapper.jsonToEntity(response.data[0]);
        return service;
      }
      return null;
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) throw ServiceNotFound();
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<Service?> getComingService(int userId) async {
    try {
      final response = await dio.get('/services/coming?id=$userId');
      if (response.data.runtimeType != Null) {
        final service = ServiceMapper.jsonToEntity(response.data[0]);
        return service;
      }
      return null;
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) throw ServiceNotFound();
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<Service>> getHistory(
      {int userId = 0, int limit = 10, int offset = 0}) async {
    final response = await dio.get<List>(
        '/services/dashboard?limit=$limit&offset=$offset&id=$userId');
    final List<Service> services = [];

    for (var service in response.data ?? []) {
      services.add(ServiceMapper.jsonToEntity(service));
    }

    return services;
  }
}
