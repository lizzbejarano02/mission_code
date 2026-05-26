import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../theme/colors/app_colors.dart';
import '../../../models/pregunta_model.dart';
import '../../../design_system/cards/mission_card.dart';
import '../../../design_system/buttons/mission_button.dart';
import 'edit_pregunta_screen.dart';

class PreguntaDetailScreen extends StatelessWidget {
  final PreguntaModel pregunta;
  const PreguntaDetailScreen({super.key, required this.pregunta});

  Color _diffColor(String d) => switch (d) {
        'FACIL' => AppColors.neonGreen,
        'MEDIA' => AppColors.amber,
        'DIFICIL' => AppColors.danger,
        _ => AppColors.textMuted,
      };

  @override
  Widget build(BuildContext context) {
    final p = pregunta;

    return Scaffold(
      backgroundColor: AppColors.bg800,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Center(
            child: SizedBox(
              width: 600,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cabecera
                  Row(children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.surface600,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Icon(Icons.arrow_back,
                            color: AppColors.textSecondary, size: 18),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Text('Detalle de pregunta',
                        style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w700)),
                  ]).animate().fadeIn(),
                  const SizedBox(height: 24),

                  // Enunciado
                  MissionCard(
                    borderColor: _diffColor(p.dificultad).withOpacity(0.3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          _Badge(
                              label: p.dificultad,
                              color: _diffColor(p.dificultad)),
                          const SizedBox(width: 8),
                          _Badge(
                              label: p.tipo.replaceAll('_', ' '),
                              color: AppColors.neonBlue),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.amber.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('${p.puntos} pts',
                                style: const TextStyle(
                                    color: AppColors.amber,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ]),
                        const SizedBox(height: 16),
                        Text(p.enunciado,
                            style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 15,
                                height: 1.6)),
                      ],
                    ),
                  ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.05),

                  const SizedBox(height: 16),

                  // Respuestas
                  if (p.opcionesRespuesta.isNotEmpty)
                    MissionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Opciones de respuesta',
                              style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 14),
                          ...p.opcionesRespuesta.map((r) => Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 11),
                                  decoration: BoxDecoration(
                                    color: AppColors.bg900,
                                    borderRadius:
                                        BorderRadius.circular(10),
                                    border: Border.all(
                                        color: AppColors.border),
                                  ),
                                  child: Row(children: [
                                    Icon(Icons.radio_button_unchecked,
                                        color: AppColors.textMuted,
                                        size: 16),
                                    const SizedBox(width: 10),
                                    Expanded(
                                        child: Text(r.texto,
                                            style: const TextStyle(
                                                color:
                                                    AppColors.textPrimary,
                                                fontSize: 13))),
                                  ]),
                                ),
                              )),
                        ],
                      ),
                    ).animate(delay: 200.ms).fadeIn(),

                  const SizedBox(height: 24),
                  MissionButton(
                    label: 'Editar pregunta',
                    icon: Icons.edit_outlined,
                    fullWidth: true,
                    variant: MissionButtonVariant.outline,
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) =>
                              EditPreguntaScreen(pregunta: p)));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(label,
          style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3)),
    );
  }
}