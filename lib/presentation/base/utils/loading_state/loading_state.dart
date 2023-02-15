import 'package:freezed_annotation/freezed_annotation.dart';
part 'loading_state.freezed.dart';

@freezed
class LoadingState<T> with _$LoadingState<T> {
  const LoadingState._();

  const factory LoadingState.loading() = _$Loading<T>;
  const factory LoadingState.ready(T data) = _$Ready<T>;
  const factory LoadingState.error() = _$Error<T>;

  T? get readyData => mapOrNull(ready: (a) => a.data);
  
  U readyMap<U>({
    required U Function() loading,
    required U Function(T data) ready,
  }) {
    return map(
      loading: (_) => loading(),
      ready: (a) => ready(a.data),
      error: (_) => loading(),
    );
  }
}
