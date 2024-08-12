import 'package:gazzer_userapp/features/cuisine/domain/models/cuisine_restaurants_model.dart';
import 'package:gazzer_userapp/interface/repository_interface.dart';

abstract class CuisineRepositoryInterface extends RepositoryInterface {
  Future<CuisineRestaurantModel?> getRestaurantList(int offset, int cuisineId);
}
