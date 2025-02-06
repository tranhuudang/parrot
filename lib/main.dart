import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_version_manager/bloc_provider_scope.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_version_manager/src/core/core.dart';
import 'package:flutter_version_manager/src/presentation/presentation.dart';
import 'package:windows_status_bar/windows_status_bar.dart';
import 'app.dart';
part 'initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _Initializer.start();
  runApp(
    const BlocProviderScope(
      child: ProviderScope(child: App()),
    ),
  );
}
