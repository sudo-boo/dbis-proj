/// 5. add_new_item.dart (wrapper for VendorItemDetailPage with item=null)

import 'package:flutter/material.dart';
import 'package:vendor/ui/vendor_item_detail_page.dart';

class AddNewItemPage extends StatelessWidget {
  const AddNewItemPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const VendorItemDetailPage(item: null);
  }
}