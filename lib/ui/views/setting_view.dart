import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/config/theme.dart';
import 'package:task_manager_app/config/theme_provider.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cài đặt"),
        backgroundColor: Color(0xFF3B5998),
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, snapshot, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ListTile(
                  title: Text("Chế độ tối"),
                  trailing: Switch(
                    activeColor: Color(0xFF3B5998),
                    value: snapshot.themeData == lightMode ? false : true,
                    onChanged: (value) {
                      snapshot.handleChangeTheme();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
