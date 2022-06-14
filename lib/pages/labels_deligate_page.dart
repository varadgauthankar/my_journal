import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/models/label.dart';

class LabelsDelegatePage extends SearchDelegate {
  List<Label> labels = [
    Label(label: 'love'),
    Label(label: 'sad'),
    Label(label: 'gegeg'),
    Label(label: 'adad'),
  ];

  List<Label> _selectedLabels = [];

  Widget _buildLabelsCheckboxList() {
    final filteredLabels =
        labels.where((element) => element.label!.contains(query)).toList();
    return StatefulBuilder(
      builder: ((context, setState) {
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
