
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:vegiffyy_vendor/models/Category/category_model.dart';
// import 'package:vegiffyy_vendor/providers/Category/category_provider.dart';

// class CategoryListScreen extends StatefulWidget {
//   const CategoryListScreen({super.key});

//   @override
//   State<CategoryListScreen> createState() => _CategoryListScreenState();
// }

// class _CategoryListScreenState extends State<CategoryListScreen> {
//   String? expandedId;

//   @override
//   void initState() {
//     super.initState();
//     context.read<CategoryProvider>().load();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<CategoryProvider>();

//     if (provider.loading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: provider.categories.length,
//       itemBuilder: (_, i) {
//         final cat = provider.categories[i];
//         final expanded = expandedId == cat.id;

//         return Card(
//           elevation: 1,
//           margin: const EdgeInsets.only(bottom: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(18),
//           ),
//           child: Column(
//             children: [
//               // ================= CATEGORY HEADER =================
//               InkWell(
//                 borderRadius: BorderRadius.circular(18),
//                 onTap: () {
//                   setState(() {
//                     expandedId = expanded ? null : cat.id;
//                   });
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Row(
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: Image.network(
//                           cat.imageUrl,
//                           width: 56,
//                           height: 56,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       const SizedBox(width: 14),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               cat.name,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               "${cat.subcategories.length} subcategories",
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 color: Colors.grey.shade600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       // ================= ACTIONS =================
//                       Row(
//                         children: [
//                           IconButton(
//                             tooltip: 'Edit',
//                             icon: const Icon(Icons.edit, color: Colors.blue),
//                             onPressed: () => _editCategory(context, cat),
//                           ),
//                           IconButton(
//                             tooltip: 'Delete',
//                             icon: const Icon(Icons.delete, color: Colors.red),
//                             onPressed: () => _confirmDelete(
//                               context,
//                               () => provider.deleteCategory(cat.id),
//                             ),
//                           ),
//                           Icon(
//                             expanded
//                                 ? Icons.keyboard_arrow_up
//                                 : Icons.keyboard_arrow_down,
//                             color: Colors.grey.shade700,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               // ================= SUBCATEGORIES =================
//               if (expanded)
//                 Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade50,
//                     borderRadius: const BorderRadius.vertical(
//                       bottom: Radius.circular(18),
//                     ),
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 8),
//                   child: Column(
//                     children: cat.subcategories.map((sub) {
//                       return ListTile(
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 20,
//                           vertical: 6,
//                         ),
//                         leading: ClipRRect(
//                           borderRadius: BorderRadius.circular(10),
//                           child: sub.imageUrl != null
//                               ? Image.network(
//                                   sub.imageUrl!,
//                                   width: 44,
//                                   height: 44,
//                                   fit: BoxFit.cover,
//                                 )
//                               : Container(
//                                   width: 44,
//                                   height: 44,
//                                   color: Colors.grey.shade300,
//                                   child: const Icon(Icons.image),
//                                 ),
//                         ),
//                         title: Text(
//                           sub.name,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               tooltip: 'Edit',
//                               icon: const Icon(Icons.edit,
//                                   color: Colors.blue),
//                               onPressed: () =>
//                                   _editSubCategory(context, cat, sub),
//                             ),
//                             IconButton(
//                               tooltip: 'Delete',
//                               icon: const Icon(Icons.delete,
//                                   color: Colors.red),
//                               onPressed: () => _confirmDelete(
//                                 context,
//                                 () => provider.deleteSubCategory(
//                                   cat.id,
//                                   sub.id,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// /* ===================== EDIT CATEGORY ===================== */

// void _editCategory(BuildContext context, CategoryModel cat) {
//   final nameCtrl = TextEditingController(text: cat.name);
//   XFile? image;

//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (_) => Padding(
//       padding: EdgeInsets.fromLTRB(
//         16,
//         16,
//         16,
//         MediaQuery.of(context).viewInsets.bottom + 16,
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Text(
//             "Edit Category",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 16),
//           TextField(
//             controller: nameCtrl,
//             decoration: const InputDecoration(
//               labelText: "Category Name",
//               border: OutlineInputBorder(),
//             ),
//           ),
//           const SizedBox(height: 12),
//           ElevatedButton.icon(
//             icon: const Icon(Icons.image),
//             label: const Text("Change Image"),
//             onPressed: () async {
//               image = await ImagePicker()
//                   .pickImage(source: ImageSource.gallery);
//             },
//           ),
//           const SizedBox(height: 16),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {
//                 context.read<CategoryProvider>().updateCategory(
//                       cat.id,
//                       nameCtrl.text,
//                       image?.path,
//                     );
//                 Navigator.pop(context);
//               },
//               child: const Text("Save Changes"),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// /* ===================== EDIT SUBCATEGORY ===================== */

// void _editSubCategory(
//     BuildContext context, CategoryModel cat, SubCategoryModel sub) {
//   final ctrl = TextEditingController(text: sub.name);
//   XFile? image;

//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (_) => Padding(
//       padding: EdgeInsets.fromLTRB(
//         16,
//         16,
//         16,
//         MediaQuery.of(context).viewInsets.bottom + 16,
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Text(
//             "Edit Subcategory",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 16),
//           TextField(
//             controller: ctrl,
//             decoration: const InputDecoration(
//               labelText: "Subcategory Name",
//               border: OutlineInputBorder(),
//             ),
//           ),
//           const SizedBox(height: 12),
//           ElevatedButton.icon(
//             icon: const Icon(Icons.image),
//             label: const Text("Change Image"),
//             onPressed: () async {
//               image = await ImagePicker()
//                   .pickImage(source: ImageSource.gallery);
//             },
//           ),
//           const SizedBox(height: 16),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {
//                 context.read<CategoryProvider>().updateSubCategory(
//                       cat.id,
//                       sub.id,
//                       ctrl.text,
//                       image?.path,
//                     );
//                 Navigator.pop(context);
//               },
//               child: const Text("Save Changes"),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// /* ===================== CONFIRM DELETE ===================== */

// void _confirmDelete(BuildContext context, VoidCallback onConfirm) {
//   showDialog(
//     context: context,
//     builder: (_) => AlertDialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       title: const Text("Confirm Delete"),
//       content: const Text("Are you sure you want to delete this item?"),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text("Cancel"),
//         ),
//         ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.red,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//             onConfirm();
//           },
//           child: const Text("Delete"),
//         ),
//       ],
//     ),
//   );
// }











import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vegiffyy_vendor/models/Category/category_model.dart';
import 'package:vegiffyy_vendor/providers/Category/category_provider.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  String? expandedId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryProvider>();
    final theme = Theme.of(context);

    if (provider.loading) {
      return Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.primary,
        ),
      );
    }

    if (provider.categories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: 80,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              "No Categories Yet",
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              "Start by adding your first category",
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.categories.length,
      itemBuilder: (_, i) {
        final cat = provider.categories[i];
        final expanded = expandedId == cat.id;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                // Category Header
                InkWell(
                  onTap: () {
                    setState(() {
                      expandedId = expanded ? null : cat.id;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Category Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            cat.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 60,
                              height: 60,
                              color: theme.colorScheme.surfaceVariant,
                              child: Icon(
                                Icons.image_not_supported,
                                color: theme.colorScheme.outline,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // Category Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cat.name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.grid_view_rounded,
                                    size: 14,
                                    color: theme.colorScheme.secondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${cat.subcategories.length} subcategories",
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Action Buttons
                        IconButton(
                          icon: Icon(
                            Icons.edit_outlined,
                            color: theme.colorScheme.primary,
                          ),
                          onPressed: () => _editCategory(context, cat),
                          tooltip: 'Edit Category',
                        ),
                        
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: theme.colorScheme.error,
                          ),
                          onPressed: () => _confirmDelete(
                            context,
                            'Category',
                            cat.name,
                            () => provider.deleteCategory(cat.id),
                          ),
                          tooltip: 'Delete Category',
                        ),
                        
                        Icon(
                          expanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: theme.colorScheme.outline,
                        ),
                      ],
                    ),
                  ),
                ),

                // Subcategories List (Expanded)
                if (expanded && cat.subcategories.isNotEmpty)
                  Container(
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                    child: Column(
                      children: [
                        Divider(
                          height: 1,
                          color: theme.colorScheme.outline.withOpacity(0.2),
                        ),
                        ...cat.subcategories.map((sub) {
                          return _SubcategoryTile(
                            subcategory: sub,
                            onEdit: () => _editSubCategory(context, cat, sub),
                            onDelete: () => _confirmDelete(
                              context,
                              'Subcategory',
                              sub.name,
                              () => provider.deleteSubCategory(cat.id, sub.id),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/* ===================== SUBCATEGORY TILE ===================== */

class _SubcategoryTile extends StatelessWidget {
  final SubCategoryModel subcategory;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _SubcategoryTile({
    required this.subcategory,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 8,
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: subcategory.imageUrl != null
            ? Image.network(
                subcategory.imageUrl!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _PlaceholderImage(size: 50),
              )
            : _PlaceholderImage(size: 50),
      ),
      title: Text(
        subcategory.name,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              Icons.edit_outlined,
              color: theme.colorScheme.primary,
              size: 20,
            ),
            onPressed: onEdit,
            tooltip: 'Edit',
            visualDensity: VisualDensity.compact,
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: theme.colorScheme.error,
              size: 20,
            ),
            onPressed: onDelete,
            tooltip: 'Delete',
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  final double size;

  const _PlaceholderImage({required this.size});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        Icons.image_outlined,
        color: theme.colorScheme.outline,
        size: size * 0.4,
      ),
    );
  }
}

/* ===================== EDIT CATEGORY ===================== */

void _editCategory(BuildContext context, CategoryModel cat) {
  final nameCtrl = TextEditingController(text: cat.name);
  final theme = Theme.of(context);
  XFile? image;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: theme.cardColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => StatefulBuilder(
      builder: (context, setModalState) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            24,
            20,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.edit_outlined,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Edit Category",
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: "Category Name",
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              
              const SizedBox(height: 20),
              
              Text(
                "Category Image",
                style: theme.textTheme.titleSmall,
              ),
              
              const SizedBox(height: 8),
              
              GestureDetector(
                onTap: () async {
                  final pickedImage = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (pickedImage != null) {
                    setModalState(() {
                      image = pickedImage;
                    });
                  }
                },
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.outline.withOpacity(0.3),
                    ),
                  ),
                  child: image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(11),
                          child: Image.file(
                            File(image!.path),
                            fit: BoxFit.cover,
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                color: theme.colorScheme.primary,
                                size: 32,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Change Image",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        if (nameCtrl.text.trim().isEmpty) return;
                        
                        context.read<CategoryProvider>().updateCategory(
                              cat.id,
                              nameCtrl.text.trim(),
                              image?.path,
                            );
                        Navigator.pop(context);
                      },
                      child: const Text("Save Changes"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}

/* ===================== EDIT SUBCATEGORY ===================== */

void _editSubCategory(
  BuildContext context,
  CategoryModel cat,
  SubCategoryModel sub,
) {
  final nameCtrl = TextEditingController(text: sub.name);
  final theme = Theme.of(context);
  XFile? image;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: theme.cardColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => StatefulBuilder(
      builder: (context, setModalState) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            24,
            20,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.edit_outlined,
                      color: theme.colorScheme.secondary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Edit Subcategory",
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: "Subcategory Name",
                  prefixIcon: Icon(Icons.label_outlined),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              
              const SizedBox(height: 20),
              
              Text(
                "Subcategory Image (Optional)",
                style: theme.textTheme.titleSmall,
              ),
              
              const SizedBox(height: 8),
              
              GestureDetector(
                onTap: () async {
                  final pickedImage = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (pickedImage != null) {
                    setModalState(() {
                      image = pickedImage;
                    });
                  }
                },
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.outline.withOpacity(0.3),
                    ),
                  ),
                  child: image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(11),
                          child: Image.file(
                            File(image!.path),
                            fit: BoxFit.cover,
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                color: theme.colorScheme.secondary,
                                size: 32,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Change Image",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        if (nameCtrl.text.trim().isEmpty) return;
                        
                        context.read<CategoryProvider>().updateSubCategory(
                              cat.id,
                              sub.id,
                              nameCtrl.text.trim(),
                              image?.path,
                            );
                        Navigator.pop(context);
                      },
                      child: const Text("Save Changes"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}

/* ===================== CONFIRM DELETE ===================== */

void _confirmDelete(
  BuildContext context,
  String itemType,
  String itemName,
  VoidCallback onConfirm,
) {
  final theme = Theme.of(context);

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: theme.colorScheme.error,
          ),
          const SizedBox(width: 12),
          Text(
            "Delete $itemType",
            style: theme.textTheme.titleLarge,
          ),
        ],
      ),
      content: RichText(
        text: TextSpan(
          style: theme.textTheme.bodyMedium,
          children: [
            const TextSpan(text: "Are you sure you want to delete "),
            TextSpan(
              text: itemName,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.error,
              ),
            ),
            const TextSpan(text: "? This action cannot be undone."),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: const Text("Delete"),
        ),
      ],
    ),
  );
}