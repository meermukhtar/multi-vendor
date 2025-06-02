import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/material.dart';

class SpeechToTextField {
  late stt.SpeechToText _speech;
  late bool _isListening;
  late TextEditingController _controller;
  late VoidCallback _setStateCallback;


  SpeechToTextField(
      TextEditingController controller, VoidCallback setStateCallback) {
    _speech = stt.SpeechToText();
    _isListening = false;
    _controller = controller;
    _setStateCallback = setStateCallback;
  }

  void listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        _setStateCallback(); // Call the callback function to trigger setState
        _isListening = true;
        _controller.text = "";
        print(
            "This text is checking debugig${_controller.text}"); // Reset the text
        _speech.listen(
          onResult: (val) {
            _setStateCallback(); // Call the callback function to trigger setState
            _controller.text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              //_confidence = val.confidence;
            }
          },
          onSoundLevelChange:
          null, // Set onSoundLevelChange to null to avoid updating the state
        );
      }
    } else {
      _setStateCallback(); // Call the callback function to trigger setState
      _isListening = false;
      _speech.stop();
    }
  }
}
