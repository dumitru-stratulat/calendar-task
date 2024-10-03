import 'package:riverpod/riverpod.dart';
import '../model/task_model.dart';
import '../viewModels/task_viewmodel.dart';


final taskServiceProvider = Provider((ref) => TaskViewModel());

final taskLocalStorageServiceProvider =
    AsyncNotifierProvider.autoDispose<TaskViewModel, List<Task>>(
  TaskViewModel.new,
);
