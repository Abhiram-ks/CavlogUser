import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinch_to_zoom_scrollable/pinch_to_zoom_scrollable.dart';
import 'package:user_panel/core/common/custom_imageshow_widget.dart' show imageshow;
import 'package:user_panel/core/utils/image/app_images.dart';

import '../../../../../core/themes/colors.dart';
import '../../../../data/repositories/messagedelete_repo.dart';

class MessageBubleWidget extends StatelessWidget {
  final String message;
  final String time;
  final String docId;
  final bool isCurrentUser;
  final bool delete;
  final bool softDelete;

  const MessageBubleWidget({
    super.key,
    required this.message,
    required this.time,
    required this.docId,
    required this.isCurrentUser,
    required this.delete,
    required this.softDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (softDelete) {
      return const SizedBox.shrink();
    }

    final bubbleColor = delete
        ? Colors.grey.shade300.withAlpha((0.6 * 255).toInt())
        : isCurrentUser
            ? AppPalette.buttonClr
            : Colors.grey.shade300;

    final textColor = delete
        ? Colors.black54
        : isCurrentUser
            ? AppPalette.whiteClr
            : AppPalette.blackClr;

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () {
          if (isCurrentUser && !delete) {
            showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) => CupertinoActionSheet(
                title: const Text(
                  'Are you sure you want to delete this message?',
                ),
                message: const Text(
                  'This action cannot be undone. Choose how you want to delete the message.',
                ),
                actions: <CupertinoActionSheetAction>[
                  CupertinoActionSheetAction(
                    onPressed: () {
                      DeleteMessage().hardDeleteMessage(docId);
                      Navigator.pop(context);
                    },
                    isDestructiveAction: true,
                    child: const Text(
                      'Delete for Everyone',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  CupertinoActionSheetAction(
                    onPressed: () {
                      DeleteMessage().softDelete(docId);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Delete for Me',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppPalette.blackClr,
                      ),
                    ),
                  ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppPalette.blackClr,
                    ),
                  ),
                ),
              ),
            );
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft:
                  isCurrentUser ? const Radius.circular(16) : Radius.zero,
              bottomRight:
                  isCurrentUser ? Radius.zero : const Radius.circular(16),
            ),
          ),
          constraints: const BoxConstraints(maxWidth: 280),
          child: Column(
            crossAxisAlignment: isCurrentUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              if (delete) ...[
                Row(
                  children: [
                    const Icon(CupertinoIcons.nosign,
                        size: 16, color: Colors.black54),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'This message was deleted',
                        style: TextStyle(
                          color: Colors.black54,
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ] else if (message.startsWith('http')) ...[
                PinchToZoomScrollableWidget(
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          backgroundColor: Colors.transparent,
                          insetPadding: EdgeInsets.zero,
                          child: InteractiveViewer(
                            child: Image.network(
                              message,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: imageshow(
                          imageUrl: message,
                          imageAsset: AppImages.barberEmpty,
                        ),
                      ),
                    ),
                  ),
                )
              ] else ...[
                Text(
                  message,
                  style: TextStyle(color: textColor, fontSize: 16),
                ),
              ],
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(
                  color: textColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}