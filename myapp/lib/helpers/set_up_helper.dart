import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bike_kollective/src_exports.dart';

// Class with widgets and message text for set_up_account.dart
class SetUpHelper {
  // Generates unformatted custom FormFieldText widget that allows all characters.
  static Widget customFormFieldText(label, mapKey, userMap) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: TextFormField(
          autofocus: true,
          decoration: InputDecoration(
            labelText: label,
            border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange)),
          ),
          onSaved: (value) {
            userMap[mapKey] = value;
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field cannot be blank.';
            }
          }),
    );
  }

  // Generates formatted custom FormFieldText widget for phone number entry.
  static Widget customFormFieldPhone(label, mapKey, userMap) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: TextFormField(
          autofocus: true,
          decoration: InputDecoration(
            labelText: label,
            border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange)),
          ),
          inputFormatters: [
            LengthLimitingTextInputFormatter(10),
            FilteringTextInputFormatter.digitsOnly
          ],
          onSaved: (value) {
            userMap[mapKey] = value;
          },
          validator: (value) {
            if (value == null || value.length < 10) {
              return 'Please enter a 10 digit phone number';
            }
          }),
    );
  }

  // Generates unformatted custom FormFieldText widget that allows all characters.
  static Widget tagFormField(label, bikeID, existingTags) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: TextFormField(
          autofocus: true,
          decoration: InputDecoration(
            labelText: label,
            border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange)),
          ),
          onSaved: (value) {
            BikeUpdate tagUpdate = BikeUpdate(bikeDocId: bikeID);
            tagUpdate.updateBikeTags(value, existingTags);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field cannot be blank.';
            }
          }),
    );
  }

  static String waiverText =
      '''I, the user, agree that I will not hurt myself or others while using a Bike Kollective bike or any other Bike Kollective service. If I do hurt myself or others while making use of a Bike Kollective bicycle, I absolve Bike Kollective and its creators of all responsibility and recognize that I will be fully liable for any damages. I also acknowledge that the Bike Kollective reserves the right bill me for anything they damn well please.''';
}
