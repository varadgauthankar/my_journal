import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:tuple/tuple.dart';

class MyQuillEditor {
  static Widget editor(
    BuildContext context, {
    bool autoFocus = false,
    required QuillController controller,
    String? placeholder,
  }) {
    return QuillEditor(
      autoFocus: autoFocus,
      controller: controller,
      customStyles: DefaultStyles(
        paragraph: DefaultTextBlockStyle(
            TextStyle(
              fontSize: 18,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
            const Tuple2(2, 2),
            const Tuple2(2, 2),
            null),
      ),
      readOnly: false,
      scrollable: true,
      focusNode: FocusNode(),
      expands: false,
      padding: EdgeInsets.zero,
      keyboardAppearance: Brightness.light,
      scrollController: ScrollController(),
      placeholder: placeholder,
      scrollPhysics: const BouncingScrollPhysics(),
      maxHeight: 300,
    );
  }

  static toolbar(
    BuildContext context, {
    required QuillController controller,
  }) {
    return QuillToolbar.basic(
      multiRowsDisplay: false,
      controller: controller,
      iconTheme: QuillIconTheme(
        iconSelectedFillColor: Theme.of(context).colorScheme.primaryContainer,
        iconSelectedColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      showFontSize: false,
      showRedo: false,
      showUndo: false,
      showCodeBlock: false,
      showColorButton: false,
      showIndent: false,
      showImageButton: false,
      showVideoButton: false,
      showInlineCode: false,
      showJustifyAlignment: false,
      showAlignmentButtons: false,
      showLink: false,
      showListCheck: false,
      showListBullets: false,
      showListNumbers: false,
      showQuote: false,
      showDividers: false,
      showDirection: false,
      showLeftAlignment: false,
      showRightAlignment: false,
      showSmallButton: false,
      showCenterAlignment: false,
      showCameraButton: false,
      showClearFormat: true,
      showBackgroundColorButton: true,
    );
  }
}
