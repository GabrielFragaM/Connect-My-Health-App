import 'package:flutter/material.dart';
import 'package:loja_virtual/LibIngles/widgetsIngles/edit_hotel_category_dialog.dart';

class HotelButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.blue,
      onPressed: (){
        showDialog(context: context,
            builder: (context) => EditHotelCategoryDialog()
        );
      },
    );
  }
}
