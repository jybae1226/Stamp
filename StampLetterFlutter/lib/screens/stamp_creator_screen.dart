import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/stamp.dart';
import '../widgets/stamp_view.dart';
import 'letter_writer_screen.dart';

class StampCreatorScreen extends StatefulWidget {
  const StampCreatorScreen({super.key});

  @override
  State<StampCreatorScreen> createState() => _StampCreatorScreenState();
}

class _StampCreatorScreenState extends State<StampCreatorScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;
  bool _isBlackAndWhite = false;
  int _price = 150;
  StampFrameStyle _selectedFrame = StampFrameStyle.classic;

  Future<void> _pickImage() async {
    final result = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (result != null) {
      setState(() {
        _pickedImage = result;
      });
    }
  }

  void _goNext() {
    if (_pickedImage == null) return;
    final stamp = Stamp(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      imagePath: _pickedImage!.path,
      isBlackAndWhite: _isBlackAndWhite,
      price: _price,
      frameStyle: _selectedFrame,
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LetterWriterScreen(stamp: stamp)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('우표 만들기')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 260,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
                child: _pickedImage == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.photo_camera_outlined, size: 44, color: Colors.black45),
                          SizedBox(height: 12),
                          Text('사진 선택하기', style: TextStyle(fontSize: 18, color: Colors.black54)),
                        ],
                      )
                    : Center(
                        child: StampView(
                          stamp: Stamp(
                            id: 'preview',
                            imagePath: _pickedImage!.path,
                            isBlackAndWhite: _isBlackAndWhite,
                            price: _price,
                            frameStyle: _selectedFrame,
                          ),
                          size: 220,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 22),
            const Text('필터 선택', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            ToggleButtons(
              onPressed: (index) {
                setState(() {
                  _isBlackAndWhite = index == 1;
                });
              },
              isSelected: [_isBlackAndWhite == false, _isBlackAndWhite == true],
              borderRadius: BorderRadius.circular(16),
              selectedBorderColor: Theme.of(context).colorScheme.primary,
              fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.12),
              children: const [
                Padding(padding: EdgeInsets.symmetric(horizontal: 18), child: Text('컬러')),
                Padding(padding: EdgeInsets.symmetric(horizontal: 18), child: Text('흑백')),
              ],
            ),
            const SizedBox(height: 22),
            const Text('가격 입력', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(border: OutlineInputBorder(), hintText: '가격을 입력하세요'),
                    onChanged: (value) {
                      final parsed = int.tryParse(value) ?? 0;
                      setState(() {
                        _price = parsed.clamp(1, 999);
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                const Text('원', style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 20),
            const Text('프레임 선택', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: StampFrameStyle.values.map((style) {
                  final selected = style == _selectedFrame;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFrame = style),
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                      decoration: BoxDecoration(
                        color: selected ? const Color(0xFFE7B6B1) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: selected ? const Color(0xFFC0392B) : Colors.grey.shade300),
                      ),
                      child: Text(style.label),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: _pickedImage == null ? null : _goNext,
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56), backgroundColor: const Color(0xFFC0392B)),
              child: const Text('다음', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
