import 'package:gazzer_userapp/features/cuisine/domain/models/cuisine_model.dart';
import 'package:gazzer_userapp/features/cuisine/domain/models/cuisine_restaurants_model.dart';

abstract class CuisineServiceInterface {
  Future<CuisineModel> getCuisineList();

  List<int?> generateCuisineIds(CuisineModel? cuisineModel);

  Future<CuisineRestaurantModel?> getRestaurantList(int offset, int cuisineId);
}
