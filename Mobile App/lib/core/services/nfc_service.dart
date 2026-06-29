// lib/core/services/nfc_service.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/nfc_manager_android.dart';
import 'package:nfc_manager/nfc_manager_ios.dart';
import 'package:ndef_record/ndef_record.dart'; // NdefMessage and NdefRecord
import 'package:flutter/foundation.dart';

class NfcService {
  NfcService._();
  static final NfcService instance = NfcService._();

  /// Checks if NFC is available on the device
  Future<bool> isNfcAvailable() async {
    try {
      final availability = await NfcManager.instance.checkAvailability();
      return availability == NfcAvailability.enabled;
    } catch (e) {
      debugPrint("NFC Check Error: $e");
      return false;
    }
  }

  /// Writes a URL to an NFC tag.
  Future<void> writeUrlToTag({
    required String url,
    required Function() onStart,
    required Function() onSuccess,
    required Function(String error) onError,
  }) async {
    bool isAvailable = await isNfcAvailable();
    if (!isAvailable) {
      onError("NFC is not available or enabled on this device.");
      return;
    }

    onStart();

    NfcManager.instance.startSession(
      pollingOptions: {
        NfcPollingOption.iso14443,
        NfcPollingOption.iso15693,
        NfcPollingOption.iso18092,
      },
      onDiscovered: (NfcTag tag) async {
        try {
          Object? ndef;
          if (Platform.isAndroid) {
            ndef = NdefAndroid.from(tag);
          } else if (Platform.isIOS) {
            ndef = NdefIos.from(tag);
          }

          if (ndef == null) {
            NfcManager.instance.stopSession();
            onError("Tag is not NDEF formatted.");
            return;
          }

          bool isWritable = false;
          if (ndef is NdefAndroid) {
            isWritable = ndef.isWritable;
          } else if (ndef is NdefIos) {
            isWritable = ndef.status == NdefStatusIos.readWrite;
          }

          if (!isWritable) {
            NfcManager.instance.stopSession();
            onError("Tag is read only.");
            return;
          }

          final uriBytes = Uint8List.fromList(Uri.parse(url).toString().codeUnits);
          final message = NdefMessage(
            records: [
              NdefRecord(
                typeNameFormat: TypeNameFormat.wellKnown,
                type: Uint8List.fromList([0x55]), // 'U'
                identifier: Uint8List(0),
                payload: Uint8List.fromList([0x00, ...uriBytes]),
              ),
            ],
          );

          if (ndef is NdefAndroid) {
            await ndef.writeNdefMessage(message);
          } else if (ndef is NdefIos) {
            await ndef.writeNdef(message);
          }

          NfcManager.instance.stopSession();
          onSuccess();
        } catch (e) {
          NfcManager.instance.stopSession();
          onError(e.toString());
        }
      },
    ).catchError((e) {
      onError(e.toString());
    });
  }
}

