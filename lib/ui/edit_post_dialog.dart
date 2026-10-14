import 'package:api_example/service/post_model.dart';
import 'package:flutter/material.dart';

class EditPostDialog extends StatefulWidget {
  final Post post;
  const EditPostDialog({super.key, required this.post});

  @override
  State<EditPostDialog> createState() => _EditPostDialogState();
}

class _EditPostDialogState extends State<EditPostDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    // نعبّي الحقول بالقيم الحالية
    _titleController = TextEditingController(text: widget.post.title);
    _bodyController = TextEditingController(text: widget.post.body);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _save() {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();
    if (title.isEmpty || body.isEmpty) return;

    // نرجّع Post جديد بنفس الـ id
    Navigator.pop(context, Post(id: widget.post.id, title: title, body: body));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('تعديل البوست'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'العنوان',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _bodyController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'المحتوى',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(onPressed: _save, child: const Text('حفظ')),
      ],
    );
  }
}
