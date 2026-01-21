import 'package:flutter/material.dart';

class ReviewFormPage extends StatelessWidget {
  final String? reviewId;

  const ReviewFormPage({
    super.key,
    this.reviewId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(reviewId != null ? 'Edit Review' : 'Write Review'),
      ),
      body: Center(
        child: Text(
          reviewId != null 
            ? 'Edit Review for ID: $reviewId'
            : 'Write New Review',
        ),
      ),
    );
  }
}
