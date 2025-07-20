// MIT License
//
// Copyright (c) 2025 Aaryan Karlapalem
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
import 'package:flutter/cupertino.dart';
import 'package:flutter_ai/gemini_key.dart';

import 'package:google_generative_ai/google_generative_ai.dart';

import 'constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: Constants.title,
      home: MainScreen(title: Constants.title),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.title});
  final String title;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _controller = TextEditingController();
  String _response = '';
  bool _isLoading = false;

  static const String _apiKey = GeminiInformation.api_key;

  Future<void> _sendToGemini(String prompt) async {
    setState(() {
      _isLoading = true;
      _response = '';
    });

    try {
      final model = GenerativeModel(model: GeminiInformation.gemini_model, apiKey: _apiKey);
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      setState(() {
        _response = response.text ?? Constants.noResponseMessage;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _response = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(Constants.title),
      ),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  Constants.mainHeader,
                  style: TextStyle(
                    fontSize: Constants.mainHeaderFontSize,
                    fontWeight: FontWeight.bold,
                  )
                ),
                const SizedBox(height: 20),
                CupertinoTextField(
                  controller: _controller,
                  placeholder: Constants.textFieldPlaceholder,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(12),
                  )
                ),
                const SizedBox(height: 20),
                CupertinoButton.filled(
                  onPressed: _isLoading ? null : () {
                    final input = _controller.text.trim();
                    if (input.isNotEmpty) {
                      _sendToGemini(input);
                    }
                  },
                  child: _isLoading ? const CupertinoActivityIndicator() : const Text(Constants.submitText),
                ),
                const SizedBox(height: 30),
                if (_response.isNotEmpty)
                  Text(
                    _response,
                    style: const TextStyle(fontSize: Constants.responseFontSize),
                  )
              ]
            )
          )
        )
      )
    );
  }
}