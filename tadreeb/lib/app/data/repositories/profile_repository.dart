import '../../core/constants/constants.dart';
import '../models/profile.dart';
import '../providers/api_provider.dart';

class ProfileRepository {
  ProfileRepository(this._apiProvider);

  final ApiProvider _apiProvider;

  Future<Profile> fetchProfile() async {
    final response = await _apiProvider.get(Constants.profile);
    return Profile.fromJson(response);
  }
}
