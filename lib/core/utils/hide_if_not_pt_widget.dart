// @dart=2.9
import 'package:flutter/material.dart';
import 'package:shhnatycemexdriver/core/constants.dart';

class HideIfNotPTWidget extends StatelessWidget {
  final Widget child;

  const HideIfNotPTWidget({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        // UsersRepository.getCurrentUser().type == USER_TYPE_PT
        //     ? this.child
        Container();
  }
}
