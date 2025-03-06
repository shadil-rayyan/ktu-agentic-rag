import 'package:flutter/material.dart';

class ChatEntry {
  String id;
  String name;
  bool isSelected;

  ChatEntry({
    required this.id,
    required this.name,
    this.isSelected = false,
  });
}

class Screen1 extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onDarkModeChanged;
  
  const Screen1({
    super.key,
    required this.isDarkMode,
    required this.onDarkModeChanged,
  });

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  final List<ChatEntry> _chatEntries = [];
  final TextEditingController _editController = TextEditingController();
  int _selectedIndex = -1;

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  void _createNewChat() {
    setState(() {
      _chatEntries.add(ChatEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'Chat ${_chatEntries.length + 1}',
      ));
      _selectedIndex = _chatEntries.length - 1;
    });
  }

  void _deleteChat(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Chat'),
        content: const Text('Are you sure you want to delete this chat?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _chatEntries.removeAt(index);
                if (_selectedIndex == index) {
                  _selectedIndex = -1;
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _startEditing(int index) {
    _editController.text = _chatEntries[index].name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Chat Name'),
        content: TextField(
          controller: _editController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter new chat name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _chatEntries[index].name = _editController.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: widget.isDarkMode 
          ? Colors.grey[900]
          : Colors.grey[100],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'AI Chat App',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: widget.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          Divider(
            color: widget.isDarkMode ? Colors.grey[800] : Colors.grey[300],
            height: 1,
          ),
          TextButton.icon(
            icon: Icon(
              Icons.add,
              color: widget.isDarkMode ? Colors.white : Colors.blue,
            ),
            label: Text(
              'New Chat',
              style: TextStyle(
                color: widget.isDarkMode ? Colors.white : Colors.blue,
              ),
            ),
            onPressed: _createNewChat,
          ),
          Divider(
            color: widget.isDarkMode ? Colors.grey[800] : Colors.grey[300],
            height: 1,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _chatEntries.length,
              itemBuilder: (context, index) {
                final entry = _chatEntries[index];
                return Material(
                  color: _selectedIndex == index
                      ? (widget.isDarkMode ? Colors.blue[900] : Colors.blue[100])
                      : Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    onLongPress: () => _deleteChat(index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ListTile(
                        title: Text(
                          entry.name,
                          style: TextStyle(
                            color: widget.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        trailing: _selectedIndex == index
                            ? IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: widget.isDarkMode ? Colors.white : Colors.blue,
                                  size: 20,
                                ),
                                onPressed: () => _startEditing(index),
                              )
                            : null,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(
            color: widget.isDarkMode ? Colors.grey[800] : Colors.grey[300],
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  widget.isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                  color: widget.isDarkMode ? Colors.white : Colors.grey,
                ),
                Switch(
                  value: widget.isDarkMode,
                  onChanged: widget.onDarkModeChanged,
                  activeColor: Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}