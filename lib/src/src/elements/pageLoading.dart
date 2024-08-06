import 'package:flutter/material.dart';

import '../utils/global.dart';

Widget pageLoading() => Center(
    child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(loadingColor)));
