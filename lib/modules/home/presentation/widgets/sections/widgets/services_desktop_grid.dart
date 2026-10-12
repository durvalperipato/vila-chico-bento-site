import 'package:flutter/material.dart';
import 'package:vila_chico_bento_site/modules/home/presentation/home_controller.dart';
import 'service_card.dart';
import 'services_carousel.dart';

class ServicesDesktopGrid extends StatelessWidget {
  const ServicesDesktopGrid({
    required this.services,
    required this.controller,
    super.key,
  });

  final List<ServiceItemData> services;
  final HomeController controller;

  Widget _buildCard(ServiceItemData service) {
    return ServiceCard(
      icon: service.icon,
      title: service.title,
      description: service.description,
      badge: service.badge,
      accentColor: service.accentColor,
      onCtaTap: () => controller.openWhatsApp(
        customMessage: service.whatsappMessage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) return const SizedBox.shrink();

    // 3 Cards: Exibe em 3 colunas perfeitamente alinhadas (igual a seção
    // Sobre Nós)
    if (services.length == 3) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildCard(services[0])),
          const SizedBox(width: 20),
          Expanded(child: _buildCard(services[1])),
          const SizedBox(width: 20),
          Expanded(child: _buildCard(services[2])),
        ],
      );
    }

    // 1 ou 2 Cards: Linha balanceada
    if (services.length <= 2) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < services.length; i++) ...[
            if (i > 0) const SizedBox(width: 20),
            Expanded(child: _buildCard(services[i])),
          ],
        ],
      );
    }

    // 4 ou mais Cards: Grid balanceada em linhas de 2
    final rows = <Widget>[];
    for (int i = 0; i < services.length; i += 2) {
      final isLastOdd = (i + 1) >= services.length;
      if (rows.isNotEmpty) {
        rows.add(const SizedBox(height: 20));
      }
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildCard(services[i])),
            const SizedBox(width: 20),
            if (!isLastOdd)
              Expanded(child: _buildCard(services[i + 1]))
            else
              const Spacer(),
          ],
        ),
      );
    }

    return Column(children: rows);
  }
}
