import 'package:flutter/material.dart';

import 'edit_perfil_category_dialog.dart';


class PerfilButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.blue,
      onPressed: (){
        showDialog(context: context,
            builder: (context) => EditPerfilCategoryDialog()
        );
      },
    );
  }
}
