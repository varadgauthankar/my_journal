import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/models/label.dart';
import 'package:my_journal/services/firestore_service.dart';
import 'package:my_journal/utils/helpers.dart';
import 'package:my_journal/widgets/exception_widget.dart';

class LabelsDelegatePage extends SearchDelegate<List<Label>> {
  final List<Label> journalLabels;

  LabelsDelegatePage({required this.journalLabels});

  final List<Label> _selectedLabels = [];

  bool isFirst = true;

  final FirestoreService? _firestoreService = FirestoreService();

  final TextEditingController _textEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _setLabels() {
    // as this there is no initState() here
    // this is a little workaround
    // please don't judge me xD
    if (isFirst) {
      _selectedLabels.clear();
      _selectedLabels.addAll(journalLabels);
      isFirst = false;
    }
  }

  Widget _buildLabelsCheckboxList() {
    _setLabels();
    return StatefulBuilder(
      builder: ((context, setState) {
        // final filteredLabels = _getAllLabels()
        // .where((element) => element.label!.contains(query))
        // .toList();
        return StreamBuilder<QuerySnapshot>(
            stream: _firestoreService?.labels?.snapshots(),
            builder: (context, snapshot) {
              // loading state
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // loading error
              if (snapshot.hasError) {
                return const ExceptionWidget(
                  isError: true,
                  isLabel: true,
                );
              }

              // empty state
              if (snapshot.data?.size == 0) {
                return const ExceptionWidget(
                  isLabel: true,
                );
              }

              // has labels state
              if (snapshot.hasData) {
                final labels =
                    snapshot.data?.docs.map((e) => Label.fromSnapshot(e));

                if (labels!
                    .where((element) => element.label!.contains(query))
                    .toList()
                    .isNotEmpty) {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: labels
                        .where((element) => element.label!.contains(query))
                        .toList()
                        .length,
                    itemBuilder: ((context, index) {
                      final label = labels
                          .where((element) => element.label!.contains(query))
                          .toList()
                          .elementAt(index);
                      return CheckboxListTile(
                        activeColor: Theme.of(context).colorScheme.primary,
                        checkColor: Theme.of(context).colorScheme.onPrimary,
                        title: Text(label.label ?? ''),
                        value: _selectedLabels.contains(label),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              if (value) {
                                _selectedLabels.add(label);
                              } else {
                                _selectedLabels.remove(label);
                              }
                            });
                          }
                        },
                      );
                    }),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                        onPressed: () {
                          Label label = Label(
                            label: query,
                          );

                          _firestoreService?.createLabel(label);
                        },
                        child: Row(
                          children: [
                            const Icon(EvaIcons.plusCircleOutline),
                            spacer(width: 8),
                            Text('Create "$query"'),
                          ],
                        )),
                  );
                }
              } else {
                return const SizedBox.shrink();
              }
            });
      }),
    );
  }

  @override
  String get searchFieldLabel => 'Search labels';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.new_label_outlined),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  title: const Text('Create new label'),
                  content: Form(
                    key: _formKey,
                    child: TextFormField(
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

                          _firestoreService?.createLabel(label);
                          _textEditingController.clear();
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('CREATE'),
                    )
                  ],
                );
              });
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, _selectedLabels),
      icon: const Icon(EvaIcons.chevronLeft),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildLabelsCheckboxList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildLabelsCheckboxList();
  }
}
