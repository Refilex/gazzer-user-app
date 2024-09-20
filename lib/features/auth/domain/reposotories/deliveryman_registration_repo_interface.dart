import 'package:gazzer_userapp/api/api_client.dart';
import 'package:gazzer_userapp/features/auth/domain/models/vehicle_model.dart';
import 'package:gazzer_userapp/interface/repository_interface.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:gazzer_userapp/features/auth/domain/models/zone_model.dart';

abstract class DeliverymanRegistrationRepoInterface
    extends RepositoryInterface {
  Future<List<VehicleModel>?> getVehicleList();

  Future<Response> registerDeliveryMan(
      Map<String, String> data,
      List<MultipartBody> multiParts,
      List<MultipartDocument> additionalDocument);

  @override
  Future<List<ZoneModel>?> getList(
      {int? offset, bool? forDeliveryRegistration});
}
