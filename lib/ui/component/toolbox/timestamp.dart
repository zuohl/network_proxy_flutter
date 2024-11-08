import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:proxypin/utils/lang.dart';

import '../text_field.dart';

/// Timestamp page
/// @author Hongen Wang
class TimestampPage extends StatefulWidget {
  final int? windowId;

  const TimestampPage({super.key, this.windowId});

  @override
  State<StatefulWidget> createState() {
    return _TimestampPageState();
  }
}

class _TimestampPageState extends State<TimestampPage> {
  AppLocalizations get localizations => AppLocalizations.of(context)!;

  TextEditingController nowTimestamp = TextEditingController();
  TextEditingController timestamp = TextEditingController();
  TextEditingController dateTime = TextEditingController();

  TextEditingController timestampOut = TextEditingController();
  TextEditingController dateTimeOut = TextEditingController();

  ButtonStyle get buttonStyle => ButtonStyle(
      padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 15, vertical: 8)),
      // textStyle: WidgetStateProperty.all<TextStyle>(TextStyle(fontSize: 14)),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))));

  @override
  void initState() {
    super.initState();

    nowTimestamp.text = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    timestamp.text = nowTimestamp.text;
    dateTime.text = DateTime.now().format();
    //定时器
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) timer.cancel();
      nowTimestamp.text = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    });
  }

  @override
  void dispose() {
    nowTimestamp.dispose();
    timestamp.dispose();
    dateTime.dispose();
    timestampOut.dispose();
    dateTimeOut.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.titleMedium;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.timestamp, style: TextStyle(fontSize: 16)), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text('${localizations.nowTimestamp}:', style: textStyle),
              const SizedBox(width: 6),
              SizedBox(
                  width: 100,
                  child: TextField(
                      controller: nowTimestamp, readOnly: true, decoration: InputDecoration(border: InputBorder.none))),
              IconButton(
                icon: Icon(Icons.copy, size: 18),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: nowTimestamp.text));
                  FlutterToastr.show(localizations.copied, context);
                },
              ),
            ],
          ),
          SizedBox(height: 15),
          Wrap(
            spacing: 10.0, runSpacing: 10.0, crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(width: 93, child: Text('${localizations.timestamp}:', style: textStyle)),
              SizedBox(
                  width: 215,
                  child: TextFormField(controller: timestamp, decoration: decoration(context, hintText: 'timestamp'))),
              FilledButton.icon(
                  icon: Icon(Icons.play_arrow_rounded),
                  style: buttonStyle,
                  label: Text(localizations.convert),
                  onPressed: () => timestampConvert(timestamp.text)),
              SizedBox(
                width: 200,
                child: TextFormField(
                    controller: timestampOut,
                    readOnly: true,
                    decoration: InputDecoration(border: OutlineInputBorder())),
              ),
            ],
          ),
          SizedBox(height: 35),
          Wrap(spacing: 10.0, runSpacing: 10.0, crossAxisAlignment: WrapCrossAlignment.center, children: [
            SizedBox(width: 93, child: Text('${localizations.time}:', style: textStyle)),
            SizedBox(
                width: 215,
                child: TextFormField(
                    controller: dateTime, decoration: decoration(context, hintText: 'yyyy-MM-dd HH:mm:ss'))),
            FilledButton.icon(
                icon: Icon(Icons.play_arrow_rounded),
                style: buttonStyle,
                label: Text(localizations.convert),
                onPressed: () => timeConvert(dateTime.text)),
            SizedBox(
                width: 200,
                child: TextFormField(
                    controller: dateTimeOut,
                    readOnly: true,
                    decoration: InputDecoration(border: OutlineInputBorder()))),
          ]),
        ],
      ),
    );
  }

  timestampConvert(String timestamp) {
    if (timestamp.isEmpty) return;
    try {
      if (timestamp.length == 13) {
        timestampOut.text = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp)).format();
        return;
      }

      if (timestamp.length == 10) {
        timestampOut.text = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp) * 1000).format();
        return;
      }
      FlutterToastr.show('Invalid timestamp', context);
    } catch (e) {
      FlutterToastr.show('Invalid timestamp', context);
    }
  }

  timeConvert(String dateTime) {
    if (dateTime.isEmpty) return;
    try {
      var date = DateTime.parse(dateTime);
      dateTimeOut.text = (date.millisecondsSinceEpoch ~/ 1000).toString();
    } catch (e) {
      FlutterToastr.show('Invalid date time', context);
    }
  }
}
