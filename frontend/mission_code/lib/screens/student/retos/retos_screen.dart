import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/colors/app_colors.dart';
import '../../../providers/game_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/game_service.dart';
import '../../../models/pregunta_model.dart';
import '../../../design_system/buttons/mission_button.dart';
import '../../../widgets/gamification/xp_bar.dart';

class RetosScreen extends ConsumerStatefulWidget {
  final int misionId;
  const RetosScreen({super.key, required this.misionId});

  @override
  ConsumerState<RetosScreen> createState() => _RetosScreenState();
}

class _RetosScreenState extends ConsumerState<RetosScreen> {
  int _preguntaActual = 0;
  int? _respuestaSeleccionada;
  bool _respondida = false;
  bool? _esCorrecta;
  int _puntosGanados = 0;
  int _puntajeSesion = 0;
  bool _enviando = false;
  String? _explicacion;
  int _tiempoTranscurrido = 0;

  List<PreguntaModel> _preguntas = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargarPreguntas();
  }

  Future<void> _cargarPreguntas() async {
    try {
      final preguntas = await ref.read(gameServiceProvider)
          .getPreguntas(misionId: widget.misionId);
      setState(() { _preguntas = preguntas; _loading = false; });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  Future<void> _responder(int respuestaId) async {
    if (_respondida || _enviando) return;
    setState(() { _respuestaSeleccionada = respuestaId; _enviando = true; });

    try {
      final result = await ref.read(gameServiceProvider).responderPregunta(
        preguntaId: _preguntas[_preguntaActual].id,
        respuestaId: respuestaId,
        tiempoSegundos: _tiempoTranscurrido,
      );

      setState(() {
        _respondida  = true;
        _esCorrecta  = result['es_correcta'];
        _puntosGanados = result['puntos_obtenidos'] ?? 0;
        _explicacion = result['explicacion'];
        if (_esCorrecta == true) _puntajeSesion += _puntosGanados;
        _enviando = false;
      });
    } catch (e) {
      setState(() => _enviando = false);
    }
  }

  void _siguiente() {
    if (_preguntaActual < _preguntas.length - 1) {
      setState(() {
        _preguntaActual++;
        _respuestaSeleccionada = null;
        _respondida = false;
        _esCorrecta = null;
        _explicacion = null;
        _tiempoTranscurrido = 0;
      });
    } else {
      _mostrarResultadoFinal();
    }
  }

  void _mostrarResultadoFinal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _ResultadoFinalDialog(
        puntaje: _puntajeSesion,
        total: _preguntas.length,
        correctas: (_puntajeSesion / 10).floor(),
        onContinue: () {
          Navigator.pop(context);
          context.pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: AppColors.bg800,
        body: Center(child: CircularProgressIndicator(color: AppColors.neonGreen)),
      );
    }

    if (_preguntas.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.bg800,
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.quiz_outlined, color: AppColors.textMuted, size: 64),
            const SizedBox(height: 16),
            const Text('No hay preguntas disponibles',
              style: TextStyle(color: AppColors.textMuted)),
            const SizedBox(height: 20),
            MissionButton(label: 'Volver', onPressed: () => context.pop(),
              variant: MissionButtonVariant.outline),
          ]),
        ),
      );
    }

    final pregunta = _preguntas[_preguntaActual];
    final progreso = (_preguntaActual + 1) / _preguntas.length;

    return Scaffold(
      backgroundColor: AppColors.bg800,
      body: SafeArea(
        child: Column(
          children: [
            // Header de progreso
            _buildProgressHeader(progreso),
            // Pregunta
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPreguntaCard(pregunta),
                    const SizedBox(height: 24),
                    _buildOpciones(pregunta),
                    if (_respondida) ...[
                      const SizedBox(height: 24),
                      _buildFeedback(),
                      const SizedBox(height: 16),
                      MissionButton(
                        label: _preguntaActual < _preguntas.length - 1
                          ? 'Siguiente pregunta →' : 'Ver resultados 🏆',
                        onPressed: _siguiente,
                        fullWidth: true,
                        variant: _esCorrecta == true
                          ? MissionButtonVariant.primary
                          : MissionButtonVariant.outline,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressHeader(double progreso) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close, color: AppColors.textMuted),
            padding: EdgeInsets.zero,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Pregunta ${_preguntaActual + 1} de ${_preguntas.length}',
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.amber.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('$_puntajeSesion XP',
                      style: const TextStyle(
                        color: AppColors.amber, fontSize: 12, fontWeight: FontWeight.w700,
                      )),
                  ),
                ]),
                const SizedBox(height: 8),
                XpBar(
                  currentXp: _preguntaActual + 1,
                  maxXp: _preguntas.length,
                  animated: false,
                  label: '',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreguntaCard(PreguntaModel pregunta) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface600,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _diffColor(pregunta.dificultad).withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(pregunta.dificultad, style: TextStyle(
                color: _diffColor(pregunta.dificultad),
                fontSize: 10, fontWeight: FontWeight.w600,
              )),
            ),
            const Spacer(),
            Text('${pregunta.puntos} pts', style: const TextStyle(
              color: AppColors.amber, fontSize: 12, fontWeight: FontWeight.w600,
            )),
          ]),
          const SizedBox(height: 16),
          Text(pregunta.enunciado, style: const TextStyle(
            color: AppColors.textPrimary, fontSize: 16, height: 1.6,
          )),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.1);
  }

  Color _diffColor(String diff) => switch (diff) {
    'FACIL'   => AppColors.neonGreen,
    'MEDIA'   => AppColors.amber,
    'DIFICIL' => AppColors.danger,
    _         => AppColors.textMuted,
  };

  Widget _buildOpciones(PreguntaModel pregunta) {
    return Column(
      children: pregunta.opcionesRespuesta.asMap().entries.map((entry) {
        final i = entry.key;
        final opcion = entry.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _OpcionWidget(
            opcion: opcion,
            seleccionada: _respuestaSeleccionada == opcion.id,
            respondida: _respondida,
            esCorrecta: _esCorrecta,
            onTap: () => _responder(opcion.id),
          ).animate(delay: Duration(milliseconds: 60 * i)).fadeIn().slideX(begin: 0.1),
        );
      }).toList(),
    );
  }

  Widget _buildFeedback() {
    final correcto = _esCorrecta == true;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (correcto ? AppColors.neonGreen : AppColors.danger).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (correcto ? AppColors.neonGreen : AppColors.danger).withOpacity(0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(
              correcto ? Icons.check_circle_outline : Icons.cancel_outlined,
              color: correcto ? AppColors.neonGreen : AppColors.danger,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              correcto ? '¡Correcto! +$_puntosGanados XP' : 'Incorrecto',
              style: TextStyle(
                color: correcto ? AppColors.neonGreen : AppColors.danger,
                fontSize: 14, fontWeight: FontWeight.w700,
              ),
            ),
          ]),
          if (_explicacion != null && _explicacion!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(_explicacion!, style: const TextStyle(
              color: AppColors.textSecondary, fontSize: 13, height: 1.5,
            )),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.95, 0.95));
  }
}

class _OpcionWidget extends StatefulWidget {
  final RespuestaOpcionModel opcion;
  final bool seleccionada;
  final bool respondida;
  final bool? esCorrecta;
  final VoidCallback onTap;

  const _OpcionWidget({
    required this.opcion, required this.seleccionada,
    required this.respondida, required this.esCorrecta, required this.onTap,
  });

  @override
  State<_OpcionWidget> createState() => _OpcionWidgetState();
}

class _OpcionWidgetState extends State<_OpcionWidget> {
  bool _hovered = false;

  Color get _borderColor {
    if (!widget.respondida) {
      return _hovered ? AppColors.neonBlue.withOpacity(0.5) : AppColors.border;
    }
    if (widget.seleccionada) {
      return widget.esCorrecta == true ? AppColors.neonGreen : AppColors.danger;
    }
    return AppColors.border;
  }

  Color get _bgColor {
    if (!widget.respondida) {
      return _hovered ? AppColors.surface400 : AppColors.surface600;
    }
    if (widget.seleccionada) {
      return widget.esCorrecta == true
          ? AppColors.neonGreen.withOpacity(0.1)
          : AppColors.danger.withOpacity(0.1);
    }
    return AppColors.surface600;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.respondida ? null : widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: _bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _borderColor, width: widget.seleccionada ? 1.5 : 1),
          ),
          child: Row(children: [
            Text(widget.opcion.texto, style: const TextStyle(
              color: AppColors.textPrimary, fontSize: 14, height: 1.4,
            )),
          ]),
        ),
      ),
    );
  }
}

class _ResultadoFinalDialog extends StatelessWidget {
  final int puntaje;
  final int total;
  final int correctas;
  final VoidCallback onContinue;

  const _ResultadoFinalDialog({
    required this.puntaje, required this.total,
    required this.correctas, required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface600,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🏆', style: const TextStyle(fontSize: 56)).animate()
                .scale(begin: const Offset(0.5, 0.5), duration: 600.ms, curve: Curves.elasticOut),
            const SizedBox(height: 16),
            const Text('¡Misión completada!', style: TextStyle(
              color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w700,
            )),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.neonGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.neonGreen.withOpacity(0.3)),
              ),
              child: Text('$puntaje XP',
                style: const TextStyle(
                  fontFamily: 'Orbitron',
                  color: AppColors.neonGreen,
                  fontSize: 36, fontWeight: FontWeight.w700,
                )).animate().fadeIn(delay: 400.ms),
            ),
            const SizedBox(height: 24),
            MissionButton(
              label: 'Continuar',
              onPressed: onContinue,
              fullWidth: true,
              icon: Icons.arrow_forward,
            ),
          ],
        ),
      ),
    );
  }
}