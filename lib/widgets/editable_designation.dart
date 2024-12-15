import 'package:flutter/material.dart';

class EditableDesignationTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String initialValue;
  final Function(String) onSave;
  final Future<List<DropdownMenuItem<String>>> Function() fetchDesignations;

  const EditableDesignationTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.initialValue,
    required this.onSave,
    required this.fetchDesignations,
  }) : super(key: key);

  @override
  _EditableDesignationTileState createState() => _EditableDesignationTileState();
}

class _EditableDesignationTileState extends State<EditableDesignationTile> {
  bool _isEditing = false;
  String? _selectedDesignation;
  String? initialDesignation;

  @override
  void initState() {
    super.initState();
    _selectedDesignation = null;
    //initialLocation = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
     leading: Icon(widget.icon),
      title: Text(widget.title),
      subtitle: _isEditing ? buildDropdown() : buildText(),
      trailing: _isEditing ? buildSaveButton() : buildEditIcon(),
    );
  }

  Widget buildDropdown() {
    return FutureBuilder<List<DropdownMenuItem<String>>>(
      future: widget.fetchDesignations(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return
            DropdownButtonFormField<String>(
              value: _selectedDesignation,
              hint: const Text('Select Designation'),
              decoration: const InputDecoration(
                labelText:null,
                // contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              ),
              items: snapshot.data!.map((item) {
                return DropdownMenuItem<String>(
                  value: item.value,
                  child: Container(
                    //height:150,// Container is now the child of DropdownMenuItem
                    margin: const EdgeInsets.symmetric(vertical: 2.5), // Add padding to Container
                    child: item.child,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDesignation = value;
                });
              },
              isExpanded: true,
            );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget buildText() {
    return Text(_selectedDesignation ?? widget.initialValue);
  }

  Widget buildEditIcon() {
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () {
        setState(() {
          _isEditing = true;
        });
      },
    );
  }

  Widget buildSaveButton() {
    return TextButton(
      onPressed: () {
        if (_selectedDesignation != null) {
          widget.onSave(_selectedDesignation!);
          setState(() {
            _isEditing = false;
          });
        }
      },
      child: const Text("Save"),
    );
  }
}