import 'package:level_up/data/services/gamification/gamification_service.dart';
import 'package:level_up/data/services/gamification/models/rating_balance_response.dart';

abstract class IGamificationRepository {
  Future<RatingBalanceData> getRatingBalance();
}

class GamificationRepository implements IGamificationRepository {
  GamificationRepository(this._service);

  final GamificationService _service;

  @override
  Future<RatingBalanceData> getRatingBalance() async {
    final response = await _service.getRatingBalance();
    return response.data;
  }
}
