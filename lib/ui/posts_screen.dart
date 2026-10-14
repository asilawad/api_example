import 'package:api_example/ui/add_post_screen.dart';
import 'package:api_example/service/api_service.dart';
import 'package:api_example/service/post_model.dart';
import 'package:api_example/ui/edit_post_dialog.dart';
import 'package:flutter/material.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final _service = PostService();
  List<Post> _posts = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      final posts = await _service.getPosts();

      setState(() {
        _posts = posts;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('صار خطأ: $e')));
    }
  }

  Future<void> _openAddScreen() async {
    final newPost = await Navigator.push<Post>(
      context,
      MaterialPageRoute(builder: (_) => const AddPostScreen()),
    );

    if (newPost != null) {
      setState(() => _posts.insert(0, newPost));
    }
  }

  Future<void> _editPost(int index) async {
    final old = _posts[index];

    final edited = await showDialog<Post>(
      context: context,
      builder: (_) => EditPostDialog(post: old),
    );
    if (edited == null) return;

    try {
      final updated = await _service.updatePost(old.id!, edited);
      if (!mounted) return;
      setState(() => _posts[index] = updated);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('صار خطأ: $e')));
    }
  }

  Future<void> _deletePost(int index) async {
    final post = _posts[index];

    try {
      await _service.deletePost(post.id!);
      if (!mounted) return;
      setState(() => _posts.removeAt(index));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('صار خطأ: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('البوستات')),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddScreen,
        child: const Icon(Icons.add),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text('صار خطأ: $_error'));
    }
    if (_posts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'ما في أي بوست حالياً',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _posts.length,
      itemBuilder: (context, i) {
        final post = _posts[i];
        return Card(
          child: ListTile(
            title: Text(post.title),
            subtitle: Text(post.body),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _editPost(i),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deletePost(i),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
