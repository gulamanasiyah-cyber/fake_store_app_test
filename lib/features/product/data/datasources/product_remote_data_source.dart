import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final DioClient dioClient;

  ProductRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await dioClient.dio.get('/products');
      if (response.statusCode == 200) {
        final data = response.data as List;
        return data.map((json) => ProductModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Server returned status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
