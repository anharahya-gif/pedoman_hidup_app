import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pedoman_hidup_app/app.dart';
import 'package:pedoman_hidup_app/shared/providers.dart';
import 'package:pedoman_hidup_app/core/utils/audio_player_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp();

  // Inisialisasi SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Inisialisasi AudioPlayerHelper
  await AudioPlayerHelper().init();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const PedomanHidupApp(),
    ),
  );
}
