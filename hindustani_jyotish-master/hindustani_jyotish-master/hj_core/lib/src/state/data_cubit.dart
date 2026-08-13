import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../network/api_exception.dart';

/// State for an async-loaded value. Carries the last-known [dataOrNull] across
/// refreshes/errors so pull-to-refresh keeps the current content on screen.
sealed class DataState<T> extends Equatable {
  const DataState();

  T? get dataOrNull {
    final s = this;
    if (s is DataLoaded<T>) return s.data;
    if (s is DataError<T>) return s.data;
    return null;
  }

  String? get errorMessage {
    final s = this;
    return s is DataError<T> ? s.message : null;
  }

  bool get isLoading => this is DataLoading<T>;

  @override
  List<Object?> get props => [dataOrNull, errorMessage];
}

class DataInitial<T> extends DataState<T> {
  const DataInitial();
}

class DataLoading<T> extends DataState<T> {
  const DataLoading();
}

class DataLoaded<T> extends DataState<T> {
  const DataLoaded(this.data);
  final T data;
  @override
  List<Object?> get props => [data];
}

class DataError<T> extends DataState<T> {
  const DataError(this.message, {this.data});
  final String message;
  final T? data;
  @override
  List<Object?> get props => [message, data];
}

/// A tiny Cubit that loads a value via [loader]. Use [load] for the first fetch
/// (shows a spinner) and [refresh] for pull-to-refresh (keeps current content).
class DataCubit<T> extends Cubit<DataState<T>> {
  DataCubit(this.loader) : super(DataInitial<T>());

  final Future<T> Function() loader;

  Future<void> load() async {
    emit(DataLoading<T>());
    await _run();
  }

  Future<void> refresh() => _run();

  /// Publish data the caller already fetched itself.
  ///
  /// For background polling: a screen that quietly re-fetches on a timer wants
  /// to show a *successful* update but must not let a transient failure emit
  /// DataError and take over the screen, which is what [refresh] would do.
  void emitLoaded(T data) => emit(DataLoaded<T>(data));

  Future<void> _run() async {
    try {
      emit(DataLoaded<T>(await loader()));
    } on ApiException catch (e) {
      emit(DataError<T>(e.message, data: state.dataOrNull));
    } catch (e) {
      // Never surface a raw exception string (SocketException, TypeError,
      // FormatException, …) to the user — log it for diagnosis and show a
      // clean, generic message instead. Network failures already arrive as
      // ApiException with a friendly message via ApiClient._normalise.
      debugPrint('[DataCubit] loader failed: $e');
      emit(DataError<T>(
        'Something went wrong. Please try again.',
        data: state.dataOrNull,
      ));
    }
  }
}
