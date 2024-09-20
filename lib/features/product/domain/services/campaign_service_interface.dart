import 'package:gazzer_userapp/common/models/product_model.dart';
import 'package:gazzer_userapp/features/product/domain/models/basic_campaign_model.dart';

abstract class CampaignServiceInterface {
  Future<List<BasicCampaignModel>?> getBasicCampaignList();

  Future<List<Product>?> getItemCampaignList();

  Future<BasicCampaignModel?> getCampaignDetails(String campaignID);
}
