import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kturag/localization/app_localizations.dart';
// import 'package:kturag/app/app.dart';
import 'package:kturag/main.dart';

class Screen2 extends StatefulWidget {
  final Function(Locale) onLocaleChange;

  const Screen2({super.key, required this.onLocaleChange});

  @override
  _Screen2State createState() => _Screen2State();
}


class _Screen2State extends State<Screen2> {
  List<String> installedModels = [];
  List<String> availableModels = [];
  String? selectedInstalledModel;
  String? selectedAvailableModel;
  bool isLoading = true;
  bool isDownloading = false;
  bool installingOllama = false;
  bool isOllamaInstalled = false;
  double downloadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    setupOllama();
  }

  Future<void> setupOllama() async {
    setState(() => isLoading = true);
    isOllamaInstalled = await checkOllamaInstalled();
    if (!isOllamaInstalled) {
      await installOllama();
    } else {
      await fetchInstalledModels();
      await fetchAvailableModels();
    }
    setState(() => isLoading = false);
  }

  Future<bool> checkOllamaInstalled() async {
    try {
      var result = await Process.run('ollama', ['--version']);
      return result.exitCode == 0;
    } catch (e) {
      return false;
    }
  }

  Future<void> installOllama() async {
    setState(() => installingOllama = true);
    showProgressDialog(
        AppLocalizations.of(context)!.translate("installing_ollama"));

    try {
      if (Platform.isWindows) {
        await Process.run('winget', ['install', '--id=Ollama.Ollama']);
      } else if (Platform.isMacOS) {
        await Process.run('brew', ['install', 'ollama']);
      } else if (Platform.isLinux) {
        await Process.run(
            'bash', ['-c', 'curl -fsSL https://ollama.ai/install.sh | bash']);
      }

      Navigator.pop(context);
      showSuccessDialog(
          AppLocalizations.of(context)!.translate("ollama_installed"));
      isOllamaInstalled = true;
      await fetchInstalledModels();
      await fetchAvailableModels();
    } catch (e) {
      Navigator.pop(context);
      showErrorDialog(AppLocalizations.of(context)!.translate("install_failed"));
    }

    setState(() => installingOllama = false);
  }

  Future<void> fetchInstalledModels() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:11434/api/tags'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<String> models =
            List<String>.from(data['models'].map((model) => model['name']));

        setState(() {
          installedModels = models;
          selectedInstalledModel = models.isNotEmpty ? models.first : null;
        });
      }
    } catch (e) {
      setState(() => installedModels = []);
      showErrorDialog(
          AppLocalizations.of(context)!.translate("connection_failed"));
    }
  }

  Future<void> fetchAvailableModels() async {
    try {
      final response =
          await http.get(Uri.parse('https://ollama.ai/api/models'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<String> models =
            List<String>.from(data['models'].map((model) => model['name']));

        setState(() {
          availableModels = models
              .where((model) => !installedModels.contains(model))
              .toList();
          selectedAvailableModel =
              availableModels.isNotEmpty ? availableModels.first : null;
        });
      }
    } catch (e) {
      setState(() => availableModels = []);
      showErrorDialog(AppLocalizations.of(context)!.translate("fetch_failed"));
    }
  }

  Future<void> downloadModel(String model) async {
    setState(() {
      isDownloading = true;
      downloadProgress = 0.0;
    });

    showProgressDialog(
        "${AppLocalizations.of(context)!.translate("downloading")} $model...");

    try {
      var response = await http.post(
        Uri.parse('http://localhost:11434/api/pull'),
        body: jsonEncode({'name': model}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        showSuccessDialog(
            AppLocalizations.of(context)!.translate("model_installed"));
        await fetchInstalledModels();
        await fetchAvailableModels();
      } else {
        Navigator.pop(context);
        showErrorDialog(
            AppLocalizations.of(context)!.translate("install_failed"));
      }
    } catch (e) {
      Navigator.pop(context);
      showErrorDialog(
          AppLocalizations.of(context)!.translate("error_installing"));
    }

    setState(() {
      isDownloading = false;
      downloadProgress = 0.0;
    });
  }

  void showProgressDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              LinearProgressIndicator(value: downloadProgress),
            ],
          ),
        );
      },
    );
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.translate("error")),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  void showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.translate("success")),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localization!.translate("select_model")),
        actions: [
          DropdownButton<Locale>(
            icon: const Icon(Icons.language, color: Colors.white),
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: Locale('en'), child: Text("English")),
              DropdownMenuItem(value: Locale('es'), child: Text("Español")),
            ],
            onChanged: (Locale? newLocale) {
              if (newLocale != null) {
                LanguageProvider.of(context)?.changeLanguage(newLocale);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localization!.translate("installed_models"),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (installedModels.isNotEmpty)
                    DropdownButtonFormField<String>(
                      value: selectedInstalledModel,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      items: installedModels.map((model) {
                        return DropdownMenuItem(
                            value: model, child: Text(model));
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() => selectedInstalledModel = newValue);
                      },
                    )
                  else
                    Text(localization!.translate("no_models_installed")),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: selectedInstalledModel != null
                        ? () => Navigator.pop(context, selectedInstalledModel)
                        : null,
                    child: Text(localization!.translate("save_back")),
                  ),
                ],
              ),
      ),
    );
  }
}
