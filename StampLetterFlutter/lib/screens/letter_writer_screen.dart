import 'package:flutter/material.dart';
import '../models/letter.dart';
import '../models/stamp.dart';
import '../widgets/letter_paper_view.dart';
import 'preview_save_screen.dart';

class LetterWriterScreen extends StatefulWidget {
  final Stamp stamp;

  const LetterWriterScreen({super.key, required this.stamp});

  @override
  State<LetterWriterScreen> createState() => _LetterWriterScreenState();
}

class _LetterWriterScreenState extends State<LetterWriterScreen> {
  LetterPaperStyle _selectedPaper = LetterPaperStyle.white;
  StampPosition _selectedPosition = StampPosition.topRight;
  LetterFont _selectedFont = LetterFont.handwriting;
  Color _textColor = Colors.black87;
  final TextEditingController _receiverController = TextEditingController();
  final TextEditingController _senderController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void _finish() {
    final letter = Letter(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      stamp: widget.stamp,
      paperStyle: _selectedPaper,
      stampPosition: _selectedPosition,
      content: _contentController.text,
      font: _selectedFont,
      textColor: _textColor,
      senderName: _senderController.text,
      receiverName: _receiverController.text,
      createdAt: DateTime.now(),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PreviewSaveScreen(letter: letter)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('편지 쓰기')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('미리보기', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12)],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: LetterPaperView(
                      letter: Letter(
                        id: 'preview',
                        stamp: widget.stamp,
                        paperStyle: _selectedPaper,
                        stampPosition: _selectedPosition,
                        content: _contentController.text.isEmpty ? '여기에 편지를 써주세요...' : _contentController.text,
                        font: _selectedFont,
                        textColor: _textColor,
                        senderName: _senderController.text.isEmpty ? '보낸 사람' : _senderController.text,
                        receiverName: _receiverController.text.isEmpty ? '받는 사람' : _receiverController.text,
                        createdAt: DateTime.now(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('편지지 선택', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: LetterPaperStyle.values.map((style) {
                        final selected = style == _selectedPaper;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedPaper = style),
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: selected ? const Color(0xFFFFEAE0) : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: selected ? const Color(0xFFC0392B) : Colors.grey.shade300),
                            ),
                            child: Text(style.label),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('우표 위치', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: StampPosition.values.map((position) {
                      final selected = position == _selectedPosition;
                      return ChoiceChip(
                        label: Text(position.label),
                        selected: selected,
                        onSelected: (_) => setState(() => _selectedPosition = position),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Text('폰트', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Row(
                    children: LetterFont.values.map((font) {
                      final selected = font == _selectedFont;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: OutlinedButton(
                            onPressed: () => setState(() => _selectedFont = font),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: selected ? const Color(0xFFC0392B) : Colors.grey.shade300),
                            ),
                            child: Text(font.label),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Text('글자 색상', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ColorDot(color: Colors.black87, selected: _textColor == Colors.black87, onTap: () => setState(() => _textColor = Colors.black87)),
                      _ColorDot(color: Colors.brown, selected: _textColor == Colors.brown, onTap: () => setState(() => _textColor = Colors.brown)),
                      _ColorDot(color: Colors.deepPurple, selected: _textColor == Colors.deepPurple, onTap: () => setState(() => _textColor = Colors.deepPurple)),
                      _ColorDot(color: Colors.indigo, selected: _textColor == Colors.indigo, onTap: () => setState(() => _textColor = Colors.indigo)),
                      _ColorDot(color: Colors.green.shade700, selected: _textColor == Colors.green.shade700, onTap: () => setState(() => _textColor = Colors.green.shade700)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _receiverController,
                    decoration: const InputDecoration(labelText: 'To.', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _senderController,
                    decoration: const InputDecoration(labelText: 'From.', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _contentController,
                    minLines: 6,
                    maxLines: 9,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '여기에 편지를 써주세요...',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: FilledButton(
              onPressed: _finish,
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56), backgroundColor: const Color(0xFFC0392B)),
              child: const Text('완성하기', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _ColorDot({required this.color, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: selected ? 22 : 18,
        backgroundColor: color,
        child: selected ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
      ),
    );
  }
}
