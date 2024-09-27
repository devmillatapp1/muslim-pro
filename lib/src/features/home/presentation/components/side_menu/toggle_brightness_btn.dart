import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim/src/core/di/dependency_injection.dart';
import 'package:muslim/src/features/themes/presentation/controller/cubit/theme_cubit.dart';

class ToggleBrightnessButton extends StatelessWidget {
  const ToggleBrightnessButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () {
            sl<ThemeCubit>().toggleBrightness();
          },
          icon: Icon(
            state.brightness == Brightness.dark
                ? Icons.light_mode
                : Icons.dark_mode,
          ),
        );
      },
    );
  }
}
