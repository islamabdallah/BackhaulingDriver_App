import 'package:shhnatycemexdriver/core/models/empty_response_model.dart';
import 'package:shhnatycemexdriver/core/results/result.dart';
import 'package:shhnatycemexdriver/features/truck_number/data/models/truck-number.dart';

abstract class TruckNumberRepository {
  Future<List<TruckNumberModel>> getAllAvailableTruck();
  Future<Result<EmptyResultModel>> registerTruckNumber(
      TruckNumberModel truckNumberModel);
}
