import 'package:flutter/cupertino.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Pre-warm the Liquid Glass shaders so the first frame is smooth.
  await LiquidGlassWidgets.initialize();
  runApp(LiquidGlassWidgets.wrap(child: const ShowcaseApp()));
}

class ShowcaseApp extends StatelessWidget {
  const ShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Liquid Glass Showcase',
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(brightness: Brightness.dark),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Deterministic capture states for the README screenshots, selected via
  // --dart-define=SHOT=1|2|3. SHOT=0 (default) is the normal launch state.
  static const _shot = int.fromEnvironment('SHOT');

  late int _tab = const [0, 0, 2][_shot.clamp(0, 2)];
  late bool _lighting = _shot != 2;
  late bool _reduceMotion = _shot == 2;
  late double _blur = _shot == 2 ? 0.35 : 0.7;

  late final _scroll = ScrollController(
    initialScrollOffset: const [0.0, 360.0, 250.0][_shot.clamp(0, 2)],
  );

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      // Real imagery for the glass to refract and blur.
      background: const _PhotoBackground(),
      statusBarStyle: GlassStatusBarStyle.light,
      topEdgeFade: true,
      bottomBar: GlassTabBar.bottom(
        selectedIndex: _tab,
        onTabSelected: (i) => setState(() => _tab = i),
        selectedIconColor: const Color(0xFFB794FF),
        tabs: const [
          GlassTab(
            label: 'Home',
            icon: Icon(CupertinoIcons.house),
            activeIcon: Icon(CupertinoIcons.house_fill),
          ),
          GlassTab(
            label: 'Library',
            icon: Icon(CupertinoIcons.rectangle_stack),
            activeIcon: Icon(CupertinoIcons.rectangle_stack_fill),
          ),
          GlassTab(
            label: 'Settings',
            icon: Icon(CupertinoIcons.gear),
            activeIcon: Icon(CupertinoIcons.gear_solid),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          controller: _scroll,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 140),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Liquid Glass',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: CupertinoColors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'iOS 26 glass, layered over real imagery',
                style: TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.white.withValues(alpha: 0.65),
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 24),

              const _FeaturedCard(),
              const SizedBox(height: 16),

              Row(
                children: const [
                  Expanded(
                    child: _PhotoTile(
                      photo: 'assets/photos/nature.jpg',
                      tint: Color(0xFF12B36E),
                      icon: CupertinoIcons.leaf_arrow_circlepath,
                      title: 'Nature',
                      subtitle: 'Fresh',
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: _PhotoTile(
                      photo: 'assets/photos/travel.jpg',
                      tint: Color(0xFF5A6BFF),
                      icon: CupertinoIcons.airplane,
                      title: 'Travel',
                      subtitle: 'Explore',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              const _SectionLabel('Controls'),
              const SizedBox(height: 12),
              GlassCard(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4, vertical: 4),
                  child: Column(
                    children: [
                      _SwitchRow(
                        icon: CupertinoIcons.lightbulb,
                        label: 'Dynamic lighting',
                        value: _lighting,
                        onChanged: (v) => setState(() => _lighting = v),
                      ),
                      const _Sep(),
                      _SwitchRow(
                        icon: CupertinoIcons.gauge,
                        label: 'Reduce motion',
                        value: _reduceMotion,
                        onChanged: (v) =>
                            setState(() => _reduceMotion = v),
                      ),
                      const _Sep(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 14, 12, 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(CupertinoIcons.drop,
                                    color: CupertinoColors.white, size: 20),
                                const SizedBox(width: 12),
                                const Text(
                                  'Glass blur',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: CupertinoColors.white,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${(_blur * 100).round()}%',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: CupertinoColors.white
                                        .withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            GlassSlider(
                              value: _blur,
                              onChanged: (v) => setState(() => _blur = v),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const _SectionLabel('Actions'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _GlassTextButton(
                      label: 'Share',
                      icon: CupertinoIcons.share,
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _GlassTextButton(
                      label: 'Save',
                      icon: CupertinoIcons.cloud_download,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Full-bleed photographic backdrop under the glass.
class _PhotoBackground extends StatelessWidget {
  const _PhotoBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/photos/wallpaper.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              CupertinoColors.black.withValues(alpha: 0.10),
              CupertinoColors.black.withValues(alpha: 0.35),
            ],
          ),
        ),
      ),
    );
  }
}

/// Large hero card: real photo + brand scrim + album strip + play button.
class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/photos/music.jpg', fit: BoxFit.cover),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF8B1A1A).withValues(alpha: 0.55),
                    const Color(0xFFFA2D48).withValues(alpha: 0.45),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(CupertinoIcons.music_note_2,
                          color: CupertinoColors.white, size: 26),
                      SizedBox(width: 8),
                      Text(
                        'Now Playing',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: CupertinoColors.white,
                        ),
                      ),
                      Spacer(),
                      _AlbumStrip(),
                    ],
                  ),
                  const Spacer(),
                  const Text(
                    'Liquid Glass Sessions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: CupertinoColors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Frosted controls that refract the artwork behind them',
                    style: TextStyle(
                      fontSize: 13,
                      color: CupertinoColors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 14),
                  GlassButton.custom(
                    onTap: () {},
                    height: 44,
                    width: 140,
                    shape: const LiquidRoundedSuperellipse(borderRadius: 22),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.play_fill,
                            color: CupertinoColors.white, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Play',
                          style: TextStyle(
                            color: CupertinoColors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Overlapping rounded album-art thumbnails (generated art).
class _AlbumStrip extends StatelessWidget {
  const _AlbumStrip();

  static const _covers = [
    'assets/photos/album1.jpg',
    'assets/photos/album2.jpg',
    'assets/photos/album3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 68,
      height: 38,
      child: Stack(
        children: [
          for (var i = 0; i < _covers.length; i++)
            Positioned(
              left: i * 15.0,
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: CupertinoColors.white.withValues(alpha: 0.7),
                    width: 1.5,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x55000000),
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7.5),
                  child: Image.asset(_covers[i], fit: BoxFit.cover),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Small photo tile with an accent scrim.
class _PhotoTile extends StatelessWidget {
  const _PhotoTile({
    required this.photo,
    required this.tint,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final String photo;
  final Color tint;
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(photo, fit: BoxFit.cover),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    tint.withValues(alpha: 0.35),
                    tint.withValues(alpha: 0.70),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: CupertinoColors.white, size: 22),
                  const Spacer(),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: CupertinoColors.white,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: CupertinoColors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: CupertinoColors.white, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
                fontSize: 16, color: CupertinoColors.white),
          ),
          const Spacer(),
          GlassSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _GlassTextButton extends StatelessWidget {
  const _GlassTextButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlassButton.custom(
      onTap: onTap,
      height: 54,
      width: double.infinity,
      shape: const LiquidRoundedSuperellipse(borderRadius: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: CupertinoColors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: CupertinoColors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: CupertinoColors.white,
        letterSpacing: -0.3,
      ),
    );
  }
}

class _Sep extends StatelessWidget {
  const _Sep();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: CupertinoColors.white.withValues(alpha: 0.14),
    );
  }
}
