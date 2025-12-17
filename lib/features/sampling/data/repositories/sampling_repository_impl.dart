import '../../domain/repositories/sampling_repository.dart';

class SamplingRepositoryImpl implements SamplingRepository {
  const SamplingRepositoryImpl();

  Future<T> _run<T>(Future<T> Function() function) async {
    try {
      return await function();
    } catch (e) {
      throw e;
    }
  }
}
