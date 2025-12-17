import 'sampling_remote_data_source.dart';

class SamplingRemoteDataSourceImpl implements SamplingRemoteDataSource {
  const SamplingRemoteDataSourceImpl();

  Future<T> _run<T>(Future<T> Function() function) async {
    try {
      return await function();
    } catch (e) {
      throw e;
    }
  }
}
