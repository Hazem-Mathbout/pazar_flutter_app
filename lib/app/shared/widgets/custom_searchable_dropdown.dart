// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
// import 'package:pazar/app/core/values/colors.dart';

// class CustomSearchableDropdown<T> extends StatefulWidget {
//   final String? hint;
//   final List<T>? items;
//   final Future<List<T>> Function(String? filter)? fetchItems;
//   final void Function(T?)? onChanged;
//   final T? initialValue;
//   final String Function(T)? itemAsString;
//   final String info;
//   final bool Function(T item, String filter)? customFilterFn;
//   final bool? showSearchFiled;

//   const CustomSearchableDropdown({
//     super.key,
//     this.hint,
//     required this.info,
//     this.items,
//     this.fetchItems,
//     this.onChanged,
//     this.initialValue,
//     this.itemAsString,
//     this.customFilterFn,
//     this.showSearchFiled = true,
//   });

//   @override
//   State<CustomSearchableDropdown<T>> createState() =>
//       _CustomSearchableDropdownState<T>();
// }

// class _CustomSearchableDropdownState<T>
//     extends State<CustomSearchableDropdown<T>> {
//   bool isActive = false;
//   late FocusNode _focusNode; // Declare FocusNode

//   @override
//   void initState() {
//     super.initState();
//     _focusNode = FocusNode(); // Initialize FocusNode
//     _focusNode.addListener(() {
//       // Listen to focus changes
//       setState(() {
//         isActive = _focusNode.hasFocus;
//       });
//       print("Focus state changed: ${_focusNode.hasFocus}");
//     });
//   }

//   @override
//   void dispose() {
//     _focusNode.dispose(); // Dispose the FocusNode
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         /// Label
//         Padding(
//           padding: const EdgeInsets.only(bottom: 4.0),
//           child: Text(
//             widget.info,
//             style: const TextStyle(
//               fontFamily: 'Rubik',
//               fontWeight: FontWeight.w500,
//               fontSize: 14,
//               height: 1.14,
//             ),
//           ),
//         ),
//         Container(
//           height: 50,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: const Color(0xFFF0F0F0),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               color:
//                   isActive ? const Color(0xFFDC2626) : const Color(0xFFE5E5E5),
//             ),
//             boxShadow: isActive
//                 ? [
//                     const BoxShadow(
//                       color: Color(0x66DC2626),
//                       spreadRadius: 3,
//                       blurRadius: 0,
//                     ),
//                   ]
//                 : [],
//           ),
//           child: SizedBox(
//             width: double.infinity,
//             child: DropdownSearch<T>(
//               filterFn: widget.customFilterFn,
//               items: (String filter, LoadProps? props) async {
//                 _focusNode.requestFocus();
//                 if (widget.fetchItems != null) {
//                   return await widget.fetchItems!(filter);
//                 } else {
//                   return widget.items ?? [];
//                 }
//               },
//               selectedItem: widget.initialValue,
//               compareFn: (item, selectedItem) => item == selectedItem,
//               dropdownBuilder: (context, selectedItem) {
//                 if (selectedItem == null) {
//                   return const Text(
//                     '',
//                     style: TextStyle(
//                       fontFamily: 'Rubik',
//                       fontWeight: FontWeight.w400,
//                       fontSize: 12,
//                       height: 16 /
//                           14, // Ensure this is not causing an undesired height
//                       color: Color(0xFFA3A3A3),
//                     ),
//                   );
//                 }
//                 return Text(
//                   widget.itemAsString != null
//                       ? widget.itemAsString!(selectedItem)
//                       : selectedItem.toString(),
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 12,
//                     color: Colors.black,
//                   ),
//                 );
//               },
//               suffixProps: DropdownSuffixProps(
//                 dropdownButtonProps: DropdownButtonProps(
//                   iconClosed: Image.asset(
//                     'assets/icons/selector.png',
//                     height: 16,
//                     width: 16,
//                     color: AppColors.foregroundHint,
//                   ),
//                   iconOpened: Image.asset(
//                     'assets/icons/selector.png',
//                     height: 16,
//                     width: 16,
//                     color: AppColors.foregroundHint,
//                   ),
//                 ),
//               ),
//               decoratorProps: DropDownDecoratorProps(
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide.none,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   hintText: widget.hint ?? 'اختر',
//                   hintStyle: const TextStyle(
//                     fontFamily: 'Rubik',
//                     fontWeight: FontWeight.w400,
//                     fontSize: 12,
//                     height: 16 /
//                         14, // Ensure this is not causing an undesired height
//                     color: Color(0xFFA3A3A3),
//                   ),
//                 ),
//               ),
//               popupProps: PopupProps.bottomSheet(
//                 showSearchBox: widget.showSearchFiled ?? true,

//                 // title: Text("اختر ${widget.info}"),
//                 searchFieldProps: TextFieldProps(
//                   focusNode: _focusNode,
//                   decoration: InputDecoration(
//                     hintText: "اختر ${widget.info}",
//                     hintStyle: const TextStyle(
//                       fontFamily: 'Rubik',
//                       fontSize: 14,
//                       color: Colors.grey,
//                     ),
//                     // Add rounded corners to the text field
//                     border: OutlineInputBorder(
//                       borderRadius:
//                           BorderRadius.circular(12), // Set border radius here
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(
//                           12), // Set the same radius for enabled state
//                       borderSide: const BorderSide(
//                           color: Colors.grey), // Optionally set border color
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(
//                           12), // Same border radius when focused
//                       borderSide: const BorderSide(
//                           color:
//                               AppColors.foregroundHint), // Focused border color
//                     ),
//                   ),
//                 ),
//                 itemBuilder: (context, item, isDisabled, isSelected) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 12, horizontal: 12),
//                     child: Text(
//                       widget.itemAsString != null
//                           ? widget.itemAsString!(item!)
//                           : item.toString(),
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 12,
//                       ),
//                     ),
//                   );
//                 },
//                 // modalBottomSheetProps: const ModalBottomSheetProps(
//                 //   shape: RoundedRectangleBorder(
//                 //     borderRadius: BorderRadius.all(Radius.circular(12)),
//                 //   ),
//                 // ),

//                 // bottomSheetProps: const BottomSheetProps(
//                 //   // margin: EdgeInsets.only(top: 12),
//                 //   shape: RoundedRectangleBorder(
//                 //     borderRadius: BorderRadius.all(Radius.circular(12)),
//                 //   ),
//                 // )
//                 // menuProps: const MenuProps(
//                 //   margin: EdgeInsets.only(top: 12),
//                 //   shape: RoundedRectangleBorder(
//                 //     borderRadius: BorderRadius.all(Radius.circular(12)),
//                 //   ),
//                 // ),
//               ),
//               onChanged: (value) {
//                 widget.onChanged?.call(value);
//                 // Add your additional logic here
//                 _focusNode.unfocus();
//               },
//               // onSaved: (newValue) => _focusNode.unfocus(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:pazar/app/core/values/colors.dart';
import 'package:pazar/app/shared/widgets/custom_appbar.dart';

class CustomSearchableDropdown<T> extends StatefulWidget {
  final String? hint;
  final List<T>? items;
  final Future<List<T>> Function(String? filter)? fetchItems;
  final void Function(T?)? onChanged;
  final T? initialValue;
  final String Function(T)? itemAsString;
  final String info;
  final bool Function(T item, String filter)? customFilterFn;
  final bool? showSearchFiled;

  const CustomSearchableDropdown({
    super.key,
    this.hint,
    required this.info,
    this.items,
    this.fetchItems,
    this.onChanged,
    this.initialValue,
    this.itemAsString,
    this.customFilterFn,
    this.showSearchFiled = true,
  });

  @override
  State<CustomSearchableDropdown<T>> createState() =>
      _CustomSearchableDropdownState<T>();
}

class _CustomSearchableDropdownState<T>
    extends State<CustomSearchableDropdown<T>> {
  bool isActive = false;
  late FocusNode _focusNode;
  T? _selectedItem;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _selectedItem = widget.initialValue;
    print("------------------------");
    _focusNode.addListener(() {
      setState(() {
        isActive = _focusNode.hasFocus;
      });
    });
  }

  @override
  void didUpdateWidget(CustomSearchableDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // print('Old initialValue: ${oldWidget.initialValue}');
    // print('New initialValue: ${widget.initialValue}');

    // if (widget.initialValue != oldWidget.initialValue) {
    setState(() {
      _selectedItem = widget.initialValue; // Sync with new initialValue
    });
    // }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _openSelectionPage(BuildContext context) async {
    // Navigate immediately and show loading state
    FocusManager.instance.primaryFocus?.unfocus();

    final selectedItem = await Navigator.of(context).push<T>(
      MaterialPageRoute(
        builder: (context) => _DropdownSelectionPage<T>(
          title: widget.info,
          items: widget.items ?? [],
          showSearchField: widget.showSearchFiled ?? true,
          itemAsString: widget.itemAsString,
          fetchItems: widget.fetchItems,
          customFilterFn: widget.customFilterFn,
          selectedItem: _selectedItem,
        ),
        fullscreenDialog: true,
      ),
    );

    if (selectedItem != null) {
      setState(() {
        _selectedItem = selectedItem;
      });
      widget.onChanged?.call(selectedItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Label
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            widget.info,
            style: const TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 1.14,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => _openSelectionPage(context),
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isActive
                    ? const Color(0xFFDC2626)
                    : const Color(0xFFE5E5E5),
              ),
              boxShadow: isActive
                  ? [
                      const BoxShadow(
                        color: Color(0x66DC2626),
                        spreadRadius: 3,
                        blurRadius: 0,
                      ),
                    ]
                  : [],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedItem != null
                          ? widget.itemAsString != null
                              ? widget.itemAsString!(_selectedItem as T)
                              : _selectedItem.toString()
                          : widget.hint ?? 'اختر',
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontWeight: _selectedItem != null
                            ? FontWeight.bold
                            : FontWeight.w400,
                        fontSize: 12,
                        color: _selectedItem != null
                            ? Colors.black
                            : const Color(0xFFA3A3A3),
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/icons/selector.png',
                    height: 16,
                    width: 16,
                    color: AppColors.foregroundHint,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DropdownSelectionPage<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final bool showSearchField;
  final String Function(T)? itemAsString;
  final Future<List<T>> Function(String? filter)? fetchItems;
  final bool Function(T item, String filter)? customFilterFn;
  final T? selectedItem;

  const _DropdownSelectionPage({
    required this.title,
    required this.items,
    required this.showSearchField,
    this.itemAsString,
    this.fetchItems,
    this.customFilterFn,
    this.selectedItem,
  });

  @override
  State<_DropdownSelectionPage<T>> createState() =>
      _DropdownSelectionPageState<T>();
}

class _DropdownSelectionPageState<T> extends State<_DropdownSelectionPage<T>> {
  late List<T> _filteredItems;
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _searchController.addListener(_onSearchChanged);
    _loadInitialItems();
  }

  Future<void> _loadInitialItems() async {
    if (widget.fetchItems != null && _isInitialLoad) {
      _filteredItems = await widget.fetchItems!(null);
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isInitialLoad = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isInitialLoad = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() async {
    if (widget.fetchItems != null) {
      setState(() => _isLoading = true);
      _filteredItems = await widget.fetchItems!(_searchController.text);
      setState(() => _isLoading = false);
    } else {
      setState(() {
        _filteredItems = widget.items.where((item) {
          if (widget.customFilterFn != null) {
            return widget.customFilterFn!(item, _searchController.text);
          }
          final itemText = widget.itemAsString != null
              ? widget.itemAsString!(item).toLowerCase()
              : item.toString().toLowerCase();
          return itemText.contains(_searchController.text.toLowerCase());
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          if (widget.showSearchField) ...[
            Padding(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 8,
                right: 16,
                left: 16,
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "ابحث عن ${widget.title}",
                  hintStyle: const TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.2),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged();
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredItems.isEmpty
                    ? const Center(
                        child: Text('لا توجد نتائج'),
                      )
                    : ListView.builder(
                        itemCount: _filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = _filteredItems[index];
                          return ListTile(
                            title: Text(
                              widget.itemAsString != null
                                  ? widget.itemAsString!(item)
                                  : item.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            trailing: widget.selectedItem == item
                                ? const Icon(Icons.check, color: Colors.green)
                                : null,
                            onTap: () {
                              Navigator.pop(context, item);
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
