import 'package:digicon/constants/keys.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class DebugButton extends StatelessWidget {
  const DebugButton({
    super.key,
  });

  Future<void> handleDebug() async {
    await setValue(Constants.jwtKey, "dummy");
    print(await getStringAsync(Constants.jwtKey));
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: handleDebug, icon: Icon(Icons.bug_report));
  }
}