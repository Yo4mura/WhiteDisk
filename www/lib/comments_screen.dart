import 'package:flutter/material.dart';
import 'user_profile_screen.dart';

class Comment {
  final String id;
  final String author;
  final String text;
  final DateTime timestamp;
  int likesCount;

  Comment({
    required this.id,
    required this.author,
    required this.text,
    required this.timestamp,
    this.likesCount = 0,
  });
}

class CommentsScreen extends StatefulWidget {
  final String songTitle;
  final String artist;

  const CommentsScreen({
    super.key,
    required this.songTitle,
    required this.artist,
  });

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  final Map<String, bool> _likedComments = {};
  final List<Comment> _comments = [
    Comment(
      id: '1',
      author: 'Пользователь 1',
      text: 'Отличная песня! Очень нравится.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      likesCount: 5,
    ),
    Comment(
      id: '2',
      author: 'Пользователь 2',
      text: 'Слушаю на repeat уже неделю 🔥',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      likesCount: 12,
    ),
    Comment(
      id: '3',
      author: 'Пользователь 3',
      text: 'Классный бит, кто продюсер?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      likesCount: 3,
    ),
  ];

  void _toggleLike(String commentId) {
    setState(() {
      final isLiked = _likedComments[commentId] ?? false;
      _likedComments[commentId] = !isLiked;
      
      final comment = _comments.firstWhere((c) => c.id == commentId);
      if (isLiked) {
        comment.likesCount--;
      } else {
        comment.likesCount++;
      }
    });
  }

  void _openProfile(String username) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserProfileScreen(
          username: username.toLowerCase().replaceAll(' ', ''),
          displayName: username,
          bio: 'Описание профиля пользователя',
          followers: 42,
          following: 15,
        ),
      ),
    );
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;

    setState(() {
      _comments.insert(
        0,
        Comment(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          author: 'Вы',
          text: _commentController.text.trim(),
          timestamp: DateTime.now(),
        ),
      );
    });

    _commentController.clear();
    FocusScope.of(context).unfocus();
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} дн. назад';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ч. назад';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} мин. назад';
    } else {
      return 'только что';
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171716),
      appBar: AppBar(
        backgroundColor: const Color(0xFF171716),
        elevation: 0,
        title: const Text(
          'Комментарии',
          style: TextStyle(color: Color(0xFFEFEDE3)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFEFEDE3)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Song info header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1C),
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFFEFEDE3).withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.songTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEFEDE3),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.artist,
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFFEFEDE3).withValues(alpha: 0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Comments list
          Expanded(
            child: _comments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: const Color(0xFFEFEDE3).withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Пока нет комментариев',
                          style: TextStyle(
                            fontSize: 16,
                            color: const Color(0xFFEFEDE3).withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Будьте первым!',
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xFFEFEDE3).withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _comments.length,
                    itemBuilder: (context, index) {
                      final comment = _comments[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Avatar - clickable
                            GestureDetector(
                              onTap: () => _openProfile(comment.author),
                              child: CircleAvatar(
                                radius: 28,
                                backgroundColor: const Color(0xFF3D3C38),
                                child: Text(
                                  comment.author[0].toUpperCase(),
                                  style: const TextStyle(
                                    color: Color(0xFFEFEDE3),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Comment content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        comment.author,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFFEFEDE3),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        _formatTime(comment.timestamp),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: const Color(0xFFEFEDE3)
                                              .withValues(alpha: 0.4),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    comment.text,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: const Color(0xFFEFEDE3)
                                          .withValues(alpha: 0.8),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Like button
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () => _toggleLike(comment.id),
                                        borderRadius: BorderRadius.circular(20),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                (_likedComments[comment.id] ?? false)
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                size: 18,
                                                color: (_likedComments[comment.id] ?? false)
                                                    ? Colors.red
                                                    : const Color(0xFFEFEDE3)
                                                        .withValues(alpha: 0.6),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                comment.likesCount > 0
                                                    ? comment.likesCount.toString()
                                                    : '',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: const Color(0xFFEFEDE3)
                                                      .withValues(alpha: 0.6),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          // Input field
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1C),
              border: Border(
                top: BorderSide(
                  color: const Color(0xFFEFEDE3).withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 8,
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      style: const TextStyle(color: Color(0xFFEFEDE3)),
                      decoration: InputDecoration(
                        hintText: 'Написать комментарий...',
                        hintStyle: TextStyle(
                          color: const Color(0xFFEFEDE3).withValues(alpha: 0.4),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF2A2A28),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _addComment(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _addComment,
                    icon: const Icon(
                      Icons.send,
                      color: Color(0xFFEFEDE3),
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFF2A2A28),
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
