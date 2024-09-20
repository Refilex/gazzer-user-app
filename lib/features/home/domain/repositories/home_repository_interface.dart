import 'package:gazzer_userapp/features/home/domain/models/cashback_model.dart';
import 'package:gazzer_userapp/interface/repository_interface.dart';

abstract class HomeRepositoryInterface extends RepositoryInterface {
  Future<List<CashBackModel>?> getCashBackOfferList();

  Future<CashBackModel?> getCashBackData(double amount);
}
