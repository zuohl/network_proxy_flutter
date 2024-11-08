/*
 * Copyright 2023 Hongen Wang
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:proxypin/network/components/manager/hosts_manager.dart';
import 'package:proxypin/network/util/logger.dart';
import 'package:proxypin/ui/component/widgets.dart';

///hosts设置
///@author Hongen Wang
class HostsDialog extends StatefulWidget {
  final HostsManager hostsManager;

  const HostsDialog({super.key, required this.hostsManager});

  @override
  State<HostsDialog> createState() => _HostsDialogState();
}

class _HostsDialogState extends State<HostsDialog> {
  bool changed = false;

  AppLocalizations get localizations => AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        titlePadding: const EdgeInsets.only(left: 20, top: 10, right: 15),
        contentPadding: const EdgeInsets.only(left: 20, right: 20),
        scrollable: true,
        title: Row(children: [
          Text('Hosts', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          const Expanded(child: Align(alignment: Alignment.topRight, child: CloseButton()))
        ]),
        content: SizedBox(
          width: 550,
          height: 500,
          child: Column(children: [
            Row(children: [
              Text(localizations.enable),
              const SizedBox(width: 10),
              SwitchWidget(
                  scale: 0.8,
                  value: widget.hostsManager.enabled,
                  onChanged: (value) {
                    widget.hostsManager.enabled = value;
                    changed = true;
                  }),
              const Expanded(child: SizedBox()),
              FilledButton.icon(
                  icon: const Icon(Icons.add, size: 14),
                  onPressed: add,
                  label: Text(localizations.add, style: const TextStyle(fontSize: 12))),
              const SizedBox(width: 10),
              FilledButton.icon(
                  icon: const Icon(Icons.input_rounded, size: 14),
                  onPressed: import,
                  label: Text(localizations.import, style: const TextStyle(fontSize: 12))),
              const SizedBox(width: 5),
            ]),
            const SizedBox(height: 8),
            Container(
                height: 430,
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.2))),
                child: Column(children: [
                  const SizedBox(height: 5),
                  Row(children: [
                    SizedBox(width: 80, child: Text(localizations.enable, style: const TextStyle(fontSize: 14))),
                    Container(width: 15),
                    Expanded(child: Text(localizations.domain, style: TextStyle(fontSize: 14))),
                    Container(width: 18),
                    Expanded(child: Text('To Address', style: const TextStyle(fontSize: 14))),
                  ]),
                  const Divider(thickness: 0.5),
                  Expanded(
                      child: ListView.builder(
                          itemCount: widget.hostsManager.list.length, itemBuilder: (_, index) => row(index)))
                ])),
          ]),
        ));
  }

  Widget row(int index) {
    var primaryColor = Theme.of(context).colorScheme.primary;
    var list = widget.hostsManager.list;

    return InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: primaryColor.withOpacity(0.3),
        // onSecondaryTapDown: (details) => showMenus(details, index),
        // onDoubleTap: () => showEdit(index),
        child: Container(
            color: index.isEven ? Colors.grey.withOpacity(0.1) : null,
            height: 38,
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                const SizedBox(width: 10),
                Expanded(child: Text(list[index].host, style: const TextStyle(fontSize: 14))),
                const SizedBox(width: 20),
                SwitchWidget(
                    scale: 0.65,
                    value: list[index].enabled,
                    onChanged: (val) {
                      list[index].enabled = val;
                      setState(() {
                        changed = true;
                      });
                    }),
                const SizedBox(width: 40),
                SizedBox(width: 130, child: Text(list[index].mappingAddress, style: const TextStyle(fontSize: 14)))
              ],
            )));
  }

  //导入
  import() async {
    final FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowedExtensions: ['json'], type: FileType.custom);
    var file = result?.files.single;
    if (file == null) {
      return;
    }

    try {
      List json = jsonDecode(await file.xFile.readAsString());
      for (var item in json) {
        // widget.hostList.add(item);
      }

      changed = true;
      if (mounted) {
        FlutterToastr.show(localizations.importSuccess, context);
      }
      setState(() {});
    } catch (e, t) {
      logger.e('导入失败 $file', error: e, stackTrace: t);
      if (mounted) {
        FlutterToastr.show("${localizations.importFailed} $e", context);
      }
    }
  }

  void add() {
    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (BuildContext context) => DomainAddDialog(hostList: widget.hostList)).then((value) {
    //   if (value != null) {
    //     setState(() {
    //       changed = true;
    //     });
    //   }
    // });
  }
}
