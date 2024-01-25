import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../models/item.dart';

const String baseUrl = 'http://172.30.113.160:2425';

class ApiService {
  static final ApiService instance = ApiService._init();
  static final Dio dio = Dio();
  var logger = Logger();

  ApiService._init();

  Future<List<String>> getDates() async {
    logger.log(Level.info, 'getDates');
    final response = await dio.get('$baseUrl/taskDays');
    logger.log(Level.info, response.data);
    if (response.statusCode == 200) {
      final result = response.data as List;
      return result.map((e) => e.toString()).toList();
    } else {
      logger.e(response.statusMessage);
      throw Exception(response.statusMessage);
    }
  }

  Future<List<Item>> getItemsByDate(String date) async {
    logger.log(Level.info, 'getItemsByDate');
    final response = await dio.get('$baseUrl/details/$date');
    logger.log(Level.info, response.data);
    if (response.statusCode == 200) {
      final result = response.data as List;
      return result.map((e) => Item.fromJson(e)).toList();
    } else {
      logger.e(response.statusMessage);
      throw Exception(response.statusMessage);
    }
  }

  Future<List<MapEntry<String, double>>> getTotalDuration() async {
    logger.log(Level.info, 'getTotalDuration');
    final response = await dio.get('$baseUrl/entries');
    logger.log(Level.info, response.data);
    if (response.statusCode == 200) {
      final result = response.data as List;
      var items = result.map((e) => Item.fromJson(e)).toList();
      // return a sorted list of pairs(string, int) that contain total durations of tasks for each month
      var map = <String, double>{};
      items.forEach((element) {
        var date = element.date.split('-');
        var month = date[0] + '-' + date[1];
        if (map.containsKey(month)) {
          map[month] = map[month]! + element.duration;
        } else {
          map[month] = element.duration;
        }
      });
      var list = map.entries.toList();
      list.sort((a, b) {
        int valueComparison = b.value.compareTo(a.value); // Compare values in descending order
        if (valueComparison == 0) {
          // If values are equal, compare keys in descending order as well
          return b.key.compareTo(a.key);
        } else {
          return valueComparison;
        }
      });
      return list;
    } else {
      logger.e(response.statusMessage);
      throw Exception(response.statusMessage);
    }
  }

  Future<List<MapEntry<String, int>>> getTop3Categories() async {
    logger.log(Level.info, 'getTop3Categories');
    final response = await dio.get('$baseUrl/entries');
    logger.log(Level.info, response.data);
    if (response.statusCode == 200) {
      final result = response.data as List;
      var items = result.map((e) => Item.fromJson(e)).toList();
      // return top 3 categories sorted ascending by number of tasks
      var map = <String, int>{};
      items.forEach((element) {
        if (map.containsKey(element.category)) {
          map[element.category] = map[element.category]! + 1;
        } else {
          map[element.category] = 1;
        }
      });
      var list = map.entries.toList();
      // sort descending by value and by key
      list.sort((a, b) {
        int valueComparison = b.value.compareTo(a.value); // Compare values in descending order
        if (valueComparison == 0) {
          // If values are equal, compare keys in descending order as well
          return b.key.compareTo(a.key);
        } else {
          return valueComparison;
        }
      });
      var top3 = list.sublist(0, 3);
      return top3;
    } else {
      logger.e(response.statusMessage);
      throw Exception(response.statusMessage);
    }
  }

  Future<Item> addItem(Item item) async {
    logger.log(Level.info, 'addItem: $item');
    final response =
        await dio.post('$baseUrl/task', data: item.toJsonWithoutId());
    logger.log(Level.info, response.data);
    if (response.statusCode == 200) {
      return Item.fromJson(response.data);
    } else {
      logger.e(response.statusMessage);
      logger.e(response.data);
      // ctx.response.body
      logger.e(response.requestOptions.data);
      throw Exception(response.statusMessage);
    }
  }

  void deleteItem(int id) async {
    logger.log(Level.info, 'deleteItem: $id');
    final response = await dio.delete('$baseUrl/task/$id');
    logger.log(Level.info, response.data);
    if (response.statusCode != 200) {
      logger.e(response.statusMessage);
      throw Exception(response.statusMessage);
    }
  }
}
