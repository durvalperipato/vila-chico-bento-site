import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import 'package:vila_chico_bento_site/core/theme/app_colors.dart';
import 'home_controller.dart';
import 'home_injections.dart';
import 'home_state.dart';
import 'widgets/floating/whatsapp_floating.dart';
import 'widgets/navbar.dart';
import 'widgets/sections/about_section.dart';
import 'widgets/sections/contact_cta_section.dart';
import 'widgets/sections/footer_section.dart';
import 'widgets/sections/gallery_section.dart';
import 'widgets/sections/hero_section.dart';
import 'widgets/sections/location_section.dart';
import 'widgets/sections/services_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends NanoStatePage<HomePage, HomeController> {
  @override
  NanoInjections get injections => const HomeInjections();

  @override
  Widget build(BuildContext context) {
    return NanoScaffold<HomeState, NanoMessageKey>(
      controller: controller,
      headerHeight: 86,
      backgroundColor: AppColors.bgPrimary(controller.isDarkMode),
      header: (context, state) => Navbar(controller: controller),
      floatingActionButton: (context, state) => const WhatsappFloating(),
      builder: (context, state) {
        return SingleChildScrollView(
          controller: controller.scrollController,
          child: Column(
            children: [
              HeroSection(controller: controller),
              AboutSection(controller: controller),
              ServicesSection(controller: controller),
              GallerySection(controller: controller),
              LocationSection(controller: controller),
              ContactCtaSection(controller: controller),
              FooterSection(controller: controller),
            ],
          ),
        );
      },
    );
  }
}
