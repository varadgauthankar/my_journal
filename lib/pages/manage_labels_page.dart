import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/services/firestore_service.dart';
import 'package:my_journal/widgets/exception_widget.dart';

import '../models/label.dart';

class ManageLabels extends StatefulWidget {
  const ManageLabels({Key? key}) : super(key: key);

  @override
  State<ManageLabels> createState() => _ManageLabelsState();
}

class _ManageLabelsState extends State<ManageLabels> {
  final FirestoreService _firestoreService = FirestoreService();

  final TextEditingController _textEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Labels'),
        actions: [
          IconButton(
            icon: const Icon(Icons.new_label_outlined),
            onPressed: () {
              _showCreateLabelDialog(context);
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.labels?.snapshots(),
        builder: (context, snapshot) {
          // no labels
          if (snapshot.data?.size == 0) {
            return const ExceptionWidget(isLabel: true);
          }

          // labels exist
          if (snapshot.hasData) {
            final labels =
                snapshot.data?.docs.map((e) => Label.fromSnapshot(e));
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: labels?.length,
              itemBuilder: ((context, index) {
                final label = labels?.elementAt(index);
                return ListTile(
                    onTap: () {},
                    trailing: IconButton(
                      onPressed: () {
                        _firestoreService.deleteLabel(label!);
                      },
                      icon: const Icon(Icons.delete_outline),
                    ),
                    title: Text(label?.label ?? ''));
              }),
            );
          }

          // else
          else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Future<dynamic> _showCreateLabelDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Text('Create new label'),
            content: Form(
              key: _formKey,
              child: TextFormField(
                autofocus: true,
                controller: _textEditingController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'label cannot be empty';
                  }

                  if (value.length > 12) {
                    return 'label is too long';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  label: Text('Label'),
                  hintText: 'label name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Label label = Label(
                      label: _textEditingController.text.trim(),
                    );

                    _firestoreService.createLabel(label);
                    _textEditingController.clear();
                    Navigator.pop(context);
                  }
                },
                child: const Text('CREATE'),
              )
            ],
          );
        });
  }
}
