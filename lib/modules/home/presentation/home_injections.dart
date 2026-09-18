import 'package:nano_core/nano_core.dart';
import 'home_controller.dart';

/// Container de injeção de dependências do módulo Home via [NanoInjections].
class HomeInjections extends NanoInjections {
  const HomeInjections({super.scope = 'home'});

  @override
  void binds(GetIt i) {
    i.registerFactory<HomeController>(HomeController.new);
  }
}
