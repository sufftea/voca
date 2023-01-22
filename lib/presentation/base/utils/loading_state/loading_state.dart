import 'package:freezed_annotation/freezed_annotation.dart';
part 'loading_state.freezed.dart';

@freezed
class LoadingState<T> with _$LoadingState<T> {
  factory LoadingState.loading() = _$Loading;
  factory LoadingState.ready(T data) = _$Ready<T>;
  factory LoadingState.error() = _$Error;
}
