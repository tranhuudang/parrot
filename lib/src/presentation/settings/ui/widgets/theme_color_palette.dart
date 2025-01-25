import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_version_manager/src/presentation/presentation.dart';
import 'package:flutter_version_manager/src/core/core.dart';

class ColorPaletteSelector {
  Color selectedColor;
  Color onHover;
  ColorPaletteSelector({required this.selectedColor, required this.onHover});
  ColorPaletteSelector copyWith({Color? selectedColor, Color? onHover}) {
    return ColorPaletteSelector(
        selectedColor: selectedColor ?? this.selectedColor,
        onHover: onHover ?? this.onHover);
  }
}

class ThemeColorPalette extends StatefulWidget {
  const ThemeColorPalette({
    super.key,
  });

  @override
  State<ThemeColorPalette> createState() => _ThemeColorPaletteState();
}

class _ThemeColorPaletteState extends State<ThemeColorPalette> {
  final _selectController = StreamController<ColorPaletteSelector>();
  var _colorPaletteSelector = ColorPaletteSelector(
      selectedColor: Color(Properties.instance.settings.themeColor),
      onHover: Colors.black54);

  @override
  Widget build(BuildContext context) {
    final settingBloc = context.read<SettingBloc>();

    // Generate a list of colors across the hue spectrum
    final seedColors = List<Color>.generate(24, (index) {
      final hue = index * 15.0;
      return HSVColor.fromAHSV(1.0, hue, 0.8, 0.9).toColor();
    });

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Accent color'.i18n,
            style: context.theme.textTheme.titleSmall,
          ),
        ),
        8.height,
        StreamBuilder<ColorPaletteSelector>(
          stream: _selectController.stream,
          initialData: _colorPaletteSelector,
          builder: (context, selectedColor) {
            return Wrap(
              spacing: 3,
              runSpacing: 3,
              alignment: WrapAlignment.center,
              children: seedColors.map((currentColor) {
                return InkWell(
                  onTap: () {
                    _colorPaletteSelector = _colorPaletteSelector.copyWith(
                        selectedColor: currentColor);
                    _selectController.add(_colorPaletteSelector);
                    settingBloc.add(ChangeThemeColorEvent(color: currentColor));
                  },
                  onHover: (isHover) {
                    _colorPaletteSelector = _colorPaletteSelector.copyWith(
                        onHover: currentColor);
                    _selectController.add(_colorPaletteSelector);
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: currentColor,
                          border: selectedColor.data?.onHover.value ==
                              currentColor.value
                              ? Border.all(
                            color: Colors.white,
                            width: 3,
                          )
                              : null,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      if (selectedColor.data?.selectedColor.value ==
                          currentColor.value)
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
        16.height,
        FilledButton.tonalIcon(
          onPressed: () {
            settingBloc.add(EnableAdaptiveThemeColorEvent());
          },
          icon: const Icon(Icons.auto_awesome),
          label: Text('Use System Theme'.i18n),
        ),
      ],
    );
  }
}
