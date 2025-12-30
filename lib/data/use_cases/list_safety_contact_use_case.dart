import 'package:flutter_demo_app/data/data.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class ListSafetyContactUseCaseImpl implements ListSafetyContactUseCase {
  final SafetyContactService _service;

  ListSafetyContactUseCaseImpl({
    required SafetyContactService safetyContactService,
  }) : _service = safetyContactService;

  @override
  Future<List<SafetyContactModel>> call(int page) async {
    final safetyContacts = await _service.list(page);

    return safetyContacts.map<SafetyContactModel>((item) {
      return item as SafetyContactModel;
    }).toList();
  }
}
