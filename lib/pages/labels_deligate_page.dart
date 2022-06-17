import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/models/label.dart';

class LabelsDelegatePage extends SearchDelegate<List<Label>> {
  final List<Label> journalLabels;

  LabelsDelegatePage({required this.journalLabels});

  List<Label> dummyLabels = [
    Label(label: 'love'),
    Label(label: 'sad'),
    Label(label: 'gegeg'),
    Label(label: 'adad'),
  ];

  final List<Label> _selectedLabels = [];

  bool isFirst = true;

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

  List<Label> _getAllLabels() {
    _setLabels();
    return dummyLabels;
  }

  Widget _buildLabelsCheckboxList() {
    return StatefulBuilder(
      builder: ((context, setState) {
        final filteredLabels = _getAllLabels()
            .where((element) => element.label!.contains(query))
            .toList();
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: filteredLabels.length,
          itemBuilder: ((context, index) {
            final label = filteredLabels[index];
            return CheckboxListTile(
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
          query = '';
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
